class ImportJob < ApplicationJob
  def perform(*args)
    # Use the urgent strategy because the atomic strategy would keep the feed objects in memory which might blow RAM
    Chewy.strategy(:urgent) do
      import = args[0]
      exec_action = args[1]
      
      MyplaceonlineExecutionContext.do_context(import) do
        Rails.logger.info{"Started ImportJob import: #{import.id}, exec: #{exec_action}"}
        
        if exec_action == "start" && import.import_status != Import::IMPORT_STATUS_IMPORTING
          import.import_status = Import::IMPORT_STATUS_IMPORTING
          append_message(import, "Worker Started")
          
          begin
            
            if !User.current_user.admin?
              raise "Non-admin user import not supported yet. Please contact us for an exception."
            end
            
            case import.import_type
            when Import::IMPORT_TYPE_MEDIAWIKI
              Rails.logger.debug{"ImportJob mediawiki"}
              
              import_medawiki(import)
              
            else
              raise "TODO"
            end

            append_message(import, "Finished")

            import.import_status = Import::IMPORT_STATUS_IMPORTED
            import.save!
          rescue Exception => e
            Rails.logger.info{"ImportJob error: #{Myp.error_details(e)}"}
            append_message(import, "Error: #{CGI::escapeHTML(e.to_s)}")

            import.import_status = Import::IMPORT_STATUS_ERROR
            import.save!
          end
        end

        Rails.logger.info{"Finished ImportJob"}
      end
    end
  end
  
  def append_message(import, message)
    import.import_progress = "#{import.import_progress}\n* _#{User.current_user.time_now}_: #{message}"
    import.save!
  end
  
  def import_medawiki(import)
    ActiveRecord::Base.transaction do
      
      if import.import_files.length == 0
        raise "No import files found"
      end
      
      blog = Blog.create!(
        blog_name: import.import_name,
      )

      append_message(import, "Created blog [#{blog.display}](/blogs/#{blog.id})")
      
      # Copy the files to a temporary work directory
      import.import_files.each do |file|
        append_message(import, "Processing #{file.display}")
        
        ifile = file.identity_file
        
        Rails.logger.debug{"ImportJob path: #{ifile.evaluated_path}"}
        
        # We'll process the SQL last. First we process all the files
        storage = {
          sqlfiles: [],
          uploads: [],
        }
        
        Myp.mktmpdir do |dir|
          Rails.logger.debug{"ImportJob temp dir: #{dir}"}
          
          FileUtils.cp(ifile.evaluated_path, dir)
          
          tmpfile = Pathname.new(dir).join(ifile.file_file_name)

          Rails.logger.debug{"ImportJob tmpfile: #{tmpfile}"}
          
          if ifile.file_content_type == "application/gzip"
            execute_command("gunzip #{tmpfile}")
          end
          
          process_directory(import, storage, dir, dir)

          uploads_path = IdentityFile.uploads_path
          
          storage[:uploads].each do |upload|
            uploadname = Pathname.new(upload).basename.to_s
            newfilepath = uploads_path + IdentityFile.name_to_random(name: uploadname, prefix: "MWU")
            FileUtils.cp(upload, newfilepath)
            file_hash = {
              original_filename: uploadname,
              path: newfilepath,
              size: File.size(newfilepath),
              content_type: IdentityFile.infer_content_type(path: newfilepath),
            }
            newfile = IdentityFile.create_for_path!(file_hash: file_hash)
            append_message(import, "Created file #{uploadname}")
            newblogfile = BlogFile.create!(
              identity_file: newfile
            )
            blog.blog_files << newblogfile
          end
          
          storage[:sqlfiles].each do |sqlfile|
            sqlfilename = sqlfile.to_s
            if sqlfilename.index("/maintenance/").nil? && sqlfilename.index("/tests/").nil? && sqlfilename.index("/extensions/").nil?
              append_message(import, "Processing SQL file #{sqlfile}")
              statements = File.read(sqlfile).split(/;$/)
              
              pages = nil
              texts = nil
              last_revisions = {}
              
              statements.each do |statement|
                statement.lstrip!
                if statement.start_with?("INSERT INTO `revision`")
                  revisions = Myp.parse_sql_insert(statement)
                  revisions.each do |revision|
                    last_revisions[revision[1]] = revision
                  end
                elsif statement.start_with?("INSERT INTO `page`")
                  pages = Myp.parse_sql_insert(statement, id_hash: true)
                elsif statement.start_with?("INSERT INTO `text`")
                  texts = Myp.parse_sql_insert(statement, id_hash: true)
                end
              end
              
              last_revisions.each do |page_id, revision|
                page = pages[revision[1].to_s]
                text = texts[revision[2].to_s]
                
                # If text is blank, that it's probably an image, so just skip that
                if !text.nil?
                  
                  # Page namespaces:
                  #   0: Normal page
                  #   4: About page
                  #   6: Upload
                  #   2/3: User
                  if page[0] == "0" || page[0] == "4"
                    pagename = page[1]
                    markdown = Myp.media_wiki_str_to_markdown(
                      text[0],
                      link_prefix: "/blogs/#{blog.id}/page/",
                      image_prefix: "/blogs/#{blog.id}/uploads/",
                    )
                    
                    blog_post = BlogPost.create!(
                      blog_post_title: pagename,
                      post: markdown
                    )
                    
                    append_message(import, "Imported blog post [#{pagename}](/blogs/#{blog.id}/blog_posts/#{blog_post.id})")
                    
                    blog.blog_posts << blog_post
                  end
                end
              end
            end
          end
        end
      end
      
      blog.save!
    end
  end
  
  def process_directory(import, storage, dir, root_path)
    tmpfiles = execute_command("find #{dir}/ -type f").split("\n")
    
    tmpfiles.each do |f|
      fullfname = f.to_s
      fname = Pathname.new(f).basename.to_s
      
      Rails.logger.debug{"ImportJob found file: #{f}"}
      
      #append_message(import, "Processing #{f.to_s[root_path.length+1..-1]}")
      
      if fname.end_with?(".sql")
        Rails.logger.debug{"ImportJob sql"}
        #append_message(import, "Found SQL file, assuming it's the MediaWiki database")
        storage[:sqlfiles] = storage[:sqlfiles] + [f]
      elsif fname.end_with?(".tar")
        childdir = Pathname.new(dir).join("#{fname}_expanded")
        Dir.mkdir(childdir)
        Rails.logger.debug{"ImportJob made directory: #{childdir}"}
        execute_command("mv \"#{f}\" \"#{childdir}\" && cd \"#{childdir}\" && tar xvf \"#{fname}\" && rm \"#{fname}\"")
        process_directory(import, storage, childdir, root_path)
      elsif !fullfname.index("/images/").nil? && fullfname.index("/images/thumb/").nil? && fullfname.index("/images/archive/").nil? && fullfname.index("/skins/").nil? && fullfname.index("/extensions/").nil? && fullfname.index("/resources/").nil? && fname.index(".htaccess").nil? && fname.index("README").nil?
        #append_message(import, "Found image upload #{f.to_s[root_path.length+1..-1]}")
        storage[:uploads] = storage[:uploads] + [f]
      end
    end
  end
  
  def execute_command(message)
    result = ""
    Rails.logger.debug{"ImportJob executing: #{message}"}
    Open3.popen2e(message) do |stdin, stdout_and_stderr, wait_thr|
      result = stdout_and_stderr.read
      exit_status = wait_thr.value
      if exit_status != 0
        raise "Exit status " + exit_status.to_s + ": #{stdout_and_stderr.read}"
      end
    end
    Rails.logger.debug{"ImportJob result: #{result}"}
    result
  end
end