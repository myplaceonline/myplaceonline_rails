class ImportJob < ApplicationJob
  def perform(*args)

    ExecutionContext.stack do
      
      job_context = args.shift
      import_job_context(job_context)

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
                Rails.logger.info{"ImportJob mediawiki"}
                
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
        
        Rails.logger.info{"ImportJob path: #{ifile.evaluated_path}"}
        
        # We'll process the SQL last. First we process all the files
        storage = {
          sqlfiles: [],
          uploads: [],
        }
        
        Myp.mktmpdir do |dir|
          Rails.logger.info{"ImportJob temp dir: #{dir}"}
          
          file_name = ifile.file_file_name.gsub("/", "").gsub("..", "")
          
          FileUtils.cp(ifile.evaluated_path, "#{dir}/#{file_name}")
          
#           dir_listing = execute_command("ls -l #{dir}")
#           Rails.logger.info{"ImportJob dir_listing: #{dir_listing}"}
          
          tmpfile = Pathname.new(dir).join(file_name)

          Rails.logger.info{"ImportJob tmpfile: #{tmpfile}"}
          
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
              
              pages = {}
              texts = {}
              last_revisions = {}
              
              statements.each do |statement|
                statement.lstrip!
                if statement.start_with?("INSERT INTO `revision`")
                  revisions = Myp.parse_sql_insert(statement)
                  revisions.each do |revision|
                    last_revisions[revision[1]] = revision
                  end
                elsif statement.start_with?("INSERT INTO `page`")
                  pages.merge!(Myp.parse_sql_insert(statement, id_hash: true))
                elsif statement.start_with?("INSERT INTO `text`")
                  texts.merge!(Myp.parse_sql_insert(statement, id_hash: true))
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
                    
                    # No support for redirects yet
                    if !text[0].start_with?("#REDIRECT")
                      pagename = page[1].gsub("_", " ")
                      markdown = Myp.media_wiki_str_to_markdown(
                        text[0],
                        link_prefix: "/blogs/#{blog.id}/page/",
                        image_prefix: "/blogs/#{blog.id}/uploads/",
                      )
                      
                      blog_post = BlogPost.create!(
                        blog_post_title: pagename,
                        post: markdown,
                        import_original: text[0],
                        hide_title: true,
                        edit_type: BlogPost::EDIT_TYPE_TEXT,
                        last_updated_bottom: true,
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
      end
      
      blog.save!
    end
  end
  
  def process_directory(import, storage, dir, root_path)
    tmpfiles = execute_command("find #{dir}/ -type f").split("\n")
    
    tmpfiles.each do |f|
      fullfname = f.to_s
      fname = Pathname.new(f).basename.to_s
      
      Rails.logger.info{"ImportJob found file: #{f}"}
      
      #append_message(import, "Processing #{f.to_s[root_path.length+1..-1]}")
      
      if fname.end_with?(".sql")
        Rails.logger.info{"ImportJob sql"}
        #append_message(import, "Found SQL file, assuming it's the MediaWiki database")
        storage[:sqlfiles] = storage[:sqlfiles] + [f]
      elsif fname.end_with?(".tar")
        childdir = Pathname.new(dir).join("#{fname}_expanded")
        Dir.mkdir(childdir)
        Rails.logger.info{"ImportJob made directory: #{childdir}"}
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
    Rails.logger.info{"ImportJob executing: #{message}"}
    Open3.popen2e(message) do |stdin, stdout_and_stderr, wait_thr|
      result = stdout_and_stderr.read
      exit_status = wait_thr.value
      if exit_status != 0
        raise "Exit status " + exit_status.to_s + ": #{result}"
      end
    end
    Rails.logger.info{"ImportJob result: #{result}"}
    result
  end
end
