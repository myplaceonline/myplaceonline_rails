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
              
              #export.security_token = nil
              
              export.save!
              
              #token.destroy!
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
      Rails.logger.debug{"ExportJob temp dir: #{dir}, parameter: #{export.parameter}"}
      
      uploads_path = IdentityFile.uploads_path

      Rails.logger.debug{"ExportJob uploads_path: #{uploads_path}"}
      
      processed_links = { "/": true }
      
      scrape(export, dir, "/", processed_links)
      
      append_message(export, "Export complete. Zipping files...")

      output_name = "export_#{User.current_user.time_now.strftime("%Y%m%dT%H%M%S")}_"
      output_name = IdentityFile.name_to_random(name: ".zip", prefix: output_name)
      
      output_zip = uploads_path + output_name

      Rails.logger.debug{"ExportJob output_zip: #{output_zip}"}
      
      stdout = execute_command(command_line: "zip -r #{output_zip} *", current_directory: dir)

      Rails.logger.debug{"ExportJob stdout: #{stdout}"}
      
      FileUtils.chmod("a=rw", output_zip)
      
      file_hash = {
        original_filename: output_name,
        path: output_zip,
        size: File.size(output_zip),
        content_type: IdentityFile.infer_content_type(path: output_zip),
      }
      newfile = IdentityFile.create_for_path!(file_hash: file_hash)
      append_message(export, "Created downloadable zip: #{output_name}")
      newwrappedfile = ExportFile.create!(
        identity_file: newfile
      )
      export.export_files << newwrappedfile
    end
  end
  
  def scrape(export, dir, link, processed_links)
    path = "#{export.parameter}#{link}?security_token=#{export.security_token.security_token_value}"
    suffix = ".html"
    outname = "index"
    outname = outname.gsub(/[^a-zA-Z0-9,_\-]/, "")
    outfile = Pathname.new(dir).join(outname + suffix).to_s
    
    Rails.logger.debug{"ExportJob scrape path: #{path}, outfile: #{outfile}"}
    
    append_message(export, "Exporting website...")

    execute_command(command_line: "curl --silent --output #{outfile} --user-agent 'Myplaceonline Bot (Read-Only)' #{path}", current_directory: dir)
    
    data = File.read(outfile)

    i = 0
    while true do
      match_data = data.match(/href="([^"]+)"/, i)
      if !match_data.nil?
        link = match_data[1]
        
        if link.start_with?("/")
          x = link.index("?")
          if !x.nil?
            link = link[0..x-1]
          end
          
          if !processed_links.has_key?(link)
            processed_links[link] = true
            
            Rails.logger.debug{"ExportJob scrape link: #{link}"}
          end
          
        end
        
        i = match_data.offset(0)[1]
      else
        break
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