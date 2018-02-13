class ExportJob < ApplicationJob
  def perform(*args)

    ExecutionContext.stack do
      
      job_context = args.shift
      import_job_context(job_context)

      Chewy.strategy(:urgent) do

        export = args[0]
        exec_action = args[1]
        
        MyplaceonlineExecutionContext.do_context(export) do
          Rails.logger.info{"Started ExportJob export: #{export.id}, exec: #{exec_action}"}
          
          if exec_action == "start" && export.export_status != Export::EXPORT_STATUS_EXPORTING
            export.export_status = Export::EXPORT_STATUS_EXPORTING
            append_message(export, "Worker Started")
            
            begin
              
              case export.export_type
              when Export::EXPORT_TYPE_EVERYTHING
                Rails.logger.info{"ExportJob everything"}
                
                export_everything(export)
              else
                raise "TODO"
              end

              append_message(export, "Finished")

              export.export_status = Export::EXPORT_STATUS_EXPORTED
              
              token = export.security_token
              
              export.security_token = nil
              
              export.save!
              
              token.destroy!
            rescue Exception => e
              Rails.logger.info{"ExportJob error: #{Myp.error_details(e)}"}
              append_message(export, "Error: #{CGI::escapeHTML(e.to_s)}")

              export.export_status = Export::EXPORT_STATUS_ERROR
              export.save!
              
              Myp.warn("ExportJob error", e)
            end
          end

          Rails.logger.info{"Finished ExportJob"}
        end
      end
    end
  end
  
  def append_message(export, message)
    Rails.logger.debug{"ExportJob.append_message #{message}".green}
    export.export_progress = "#{export.export_progress}\n* _#{User.current_user.time_now}_: #{message}"
    export.save!
  end
  
  def export_everything(export)
    Myp.mktmpdir do |dir|
      Rails.logger.info{"ExportJob temp dir: #{dir}"}
      
      dir_path = Pathname.new(dir)
      
      uploads_path = IdentityFile.uploads_path

      Rails.logger.debug{"ExportJob uploads_path: #{uploads_path}"}
      append_message(export, "Exporting website. This may take hours or days. Refresh this page to check the status.")
      
      export.identity.user.identities.each do |i|
        website_domain_name = clean_filename(i.website_domain.display)
        domain_dir = dir_path.join(website_domain_name)
        if !Dir.exists?(domain_dir.to_s)
          Dir.mkdir(domain_dir.to_s)
        end
        
        identity_name = clean_filename(i.display)
        identity_dir = domain_dir.join(identity_name)
        if Dir.exists?(identity_dir.to_s)
          identity_dir = domain_dir.join(i.id.to_s)
          Dir.mkdir(identity_dir.to_s)
        else
          Dir.mkdir(identity_dir.to_s)
        end
        
        urlprefix = Rails.application.routes.url_helpers.root_url(
          protocol: Rails.configuration.default_url_options[:protocol],
          host: Rails.env.production? ? i.website_domain.main_domain : Rails.configuration.default_url_options[:host],
          port: Rails.configuration.default_url_options[:port]
        ).chomp("/")
        
        Rails.logger.debug{"ExportJob scraping identity: #{i.id}, domain: #{urlprefix}"}
        
        scrape(export, urlprefix, identity_dir.to_s, "/", i, { "/": true })
      end
      
      append_message(export, "Export complete. Compressing files...")
      
      output_name = "export_#{User.current_user.time_now.strftime("%Y%m%dT%H%M%S")}_"
      
      extension = ""
      case export.compression_type
      when Export::COMPRESSION_TYPE_ZIP
        extension = ".zip"
      when Export::COMPRESSION_TYPE_TAR_GZ
        extension = ".tar.gz"
      else
        raise "Unknown compression type #{export.compression_type}"
      end
      
      output_name = IdentityFile.name_to_random(name: "", prefix: output_name, extension: extension)
      
      output_path = uploads_path + output_name

      Rails.logger.debug{"ExportJob output_path: #{output_path}"}
      
      case export.compression_type
      when Export::COMPRESSION_TYPE_ZIP
        
        if export.encrypt_output?
          stdout = execute_command(command_line: "zip --encrypt --password \"#{clean_command_line(export.security_token.password)}\" -r #{output_path} *", current_directory: dir)
        else
          stdout = execute_command(command_line: "zip -r #{output_path} *", current_directory: dir)
        end
        
      when Export::COMPRESSION_TYPE_TAR_GZ
        stdout = execute_command(command_line: "tar czvf #{output_path} *", current_directory: dir)
      else
        raise "Unknown compression type #{export.compression_type}"
      end

      Rails.logger.debug{"ExportJob stdout: #{stdout}"}
      
      FileUtils.chmod("a=rw", output_path)
      
      if export.encrypt_output? && export.compression_type != Export::COMPRESSION_TYPE_ZIP
        
        new_output_path = output_path + ".gpg"
        
        gpgbin = "/usr/bin/gpg"
        command = "#{gpgbin} --batch --passphrase-fd 0 --yes --homedir /tmp " +
          "--no-use-agent --s2k-mode 3 --s2k-count 65536 " +
          "--force-mdc --cipher-algo AES256 --s2k-digest-algo #{OpenSSL::Digest::SHA512.new.name} " +
          "-o #{new_output_path} --symmetric #{output_path}"
        
        append_message(export, "Compression complete. Encrypting files...")
        
        Open3.popen3(command) do |stdin, stdout, stderr, wait_thr|
          stdin.write(export.security_token.password)
          stdin.close_write
          exit_status = wait_thr.value
          if exit_status != 0
            raise "Exit status " + exit_status.to_s
          end
        end
        
        FileUtils.chmod("a=rw", new_output_path)
        
        # Delete the original file
        File.delete(output_path)
        
        append_message(export, "Encryption complete. Use the free [gpg](https://gnupg.org/download/index.html) program to decrypt: gpg --output #{output_name.gsub(/_/, "\\_")} --decrypt #{output_name.gsub(/_/, "\\_")}.pgp")

        output_path = new_output_path
        output_name = output_name + ".gpg"
      end
      
      file_hash = {
        original_filename: output_name,
        path: output_path,
        size: File.size(output_path),
        content_type: IdentityFile.infer_content_type(path: output_path),
      }
      newfile = IdentityFile.create_for_path!(file_hash: file_hash)
      append_message(export, "Created downloadable file: [#{output_name.gsub(/_/, "\\_")}](#{newfile.download_name_path})")
      newwrappedfile = ExportFile.create!(
        identity_file: newfile
      )
      export.export_files << newwrappedfile
    end
  end
  
  def clean_filename(name)
    # Only allow certain characters and filter all others
    name.gsub(/[^a-zA-Z0-9,_\- ]/, "")
  end
  
  def clean_command_line(str)
    str.gsub(/['"\\`\n$]/, "")
  end
  
  def supports_symlinks(compression_type)
    compression_type == Export::COMPRESSION_TYPE_TAR_GZ
  end
  
  def try_symlink_path(outfile)
    result = nil
    if outfile.include?("/files/")
      if outfile.include?("/view/")
        result = outfile.sub(/\/view\//, "/download/")
      elsif outfile.include?("/download/")
        result = outfile.sub(/\/download\//, "/view/")
      end
    end
    result
  end
  
  def scrape(export, urlprefix, dir, link, identity, processed_links)
    path = "#{urlprefix}#{link}?security_token=#{export.security_token.security_token_value}&temp_identity_id=#{identity.id}"
    
    if !Rails.env.production?
      path = "#{path}&emulate_host=#{identity.website_domain.main_domain}"
    end
    
    target_dir = Pathname.new(dir)
    
    if link == "/"
      suffix = ".html"
      outname = "index"
    else
      
      # Extract the last component of the path
      
      if link.end_with?("/")
        link = link + "index.html"
      end
      
      suffix = ""
      outname = link[link.rindex("/")+1..-1]
      if !outname.index(".").nil?
        suffix = outname[outname.index(".")..-1]
        outname = outname[0..outname.index(".")-1]
      end
    end
    
    link_pieces = link.split("/")
    if link_pieces.length > 2
      i = 1
      while i < link_pieces.length - 1
        link_piece = clean_filename(link_pieces[i])
        target_dir = target_dir.join(link_piece)
        if !Dir.exists?(target_dir.to_s)
          Dir.mkdir(target_dir.to_s)
        end
        Rails.logger.debug{"ExportJob scrape link_piece: #{link_piece}"}
        i = i + 1
      end
    end
    
    outname = clean_filename(outname)

    if suffix == ""
      target_dir = target_dir.join(outname)
      if !Dir.exists?(target_dir.to_s)
        Dir.mkdir(target_dir.to_s)
      end
      outname = "index"
      suffix = ".html"
    end

    outfile = target_dir.join(outname + suffix).to_s
    
    Rails.logger.debug{"ExportJob downloading path: #{path}, outfile: #{outfile}"}
    
    needs_download = true
    
    if supports_symlinks(export.compression_type)
      existing_path = try_symlink_path(outfile)
      if !existing_path.nil?
        if File.exist?(existing_path)
          Rails.logger.debug{"ExportJob symlinking to #{existing_path}"}
          
          if outfile.include?("/view/")
            execute_command(command_line: "ln -s '../download/#{clean_command_line(outname + suffix)}'", current_directory: target_dir.to_s)
          elsif outfile.include?("/download/")
            execute_command(command_line: "ln -s '../view/#{clean_command_line(outname + suffix)}'", current_directory: target_dir.to_s)
          end
          
          needs_download = false
        end
      end
    end
    
    if needs_download
      
      execute_command(command_line: "curl --silent --output '#{outfile}' --user-agent 'Myplaceonline Bot (Read-Only)' '#{clean_command_line(path)}'", current_directory: dir)
      
      mime_type = IO.popen(["file", "--brief", "--mime-type", outfile], &:read).chomp
      
      if mime_type == "text/html"
        data = File.read(outfile)

        changed = false
        
        i = 0
        while true do
          match_data = data.match(/(src|href)="([^"]+)/, i)
          if !match_data.nil?
            new_link = match_data[2]
            
            if new_link.start_with?(urlprefix)
              new_link = new_link[urlprefix.length..-1]
            end
            
            if new_link.start_with?("/") && !new_link.start_with?("//")
              
              # Remove the leading / because all links need to be relative
              # on the local filesystem
              local_link = new_link[1..-1]
              
              # Add parent relative components if needed
              if link_pieces.length >= 2
                (1..link_pieces.length - 1).each do |i|
                  if local_link.start_with?("/")
                    local_link = ".." + local_link
                  else
                    local_link = "../" + local_link
                  end
                end
              end
              
              # If it's an HTML page, then we need to add /index.html
              new_link_last_piece = new_link[new_link.rindex("/")+1..-1]
              if new_link_last_piece.index(".").nil? || new_link_last_piece.end_with?(".html")
                local_link = local_link + "/index.html"
              end
              
              replacement = "#{match_data[1]}=\"#{local_link}"

              # Remove non-URL components for scrape lookup
              x = new_link.index("?")
              if !x.nil?
                new_link = new_link[0..x-1]
              end
              
              x = new_link.index("#")
              if !x.nil?
                new_link = new_link[0..x-1]
              end
              
              if !processed_links.has_key?(new_link)
                processed_links[new_link] = true
                
                Rails.logger.debug{"ExportJob scrape new_link: #{new_link}"}

                scrape(export, urlprefix, dir, new_link, identity, processed_links)
              end
              
              data = match_data.pre_match + replacement + match_data.post_match
              i = match_data.offset(0)[0] + replacement.length + 1
              
              changed = true
            else
              i = match_data.offset(0)[1]
            end
          else
            break
          end
        end
        
        if changed
          IO.write(outfile, data)
        end
      end
    end
  end
  
  def execute_command(command_line:, current_directory: nil)
    Rails.logger.debug{"ExportJob executing: #{command_line}"}
    child = Myp.spawn(command_line: command_line, current_directory: current_directory)
    Rails.logger.debug{"ExportJob result: #{child.out}"}
    child.out
  end
end
