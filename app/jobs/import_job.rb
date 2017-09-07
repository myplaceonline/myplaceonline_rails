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
              when Import::IMPORT_TYPE_WORDPRESS
                Rails.logger.info{"ImportJob wordpress"}
                
                import_wordpress(import)
                
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
          
          process_directory(
            import,
            storage,
            dir,
            dir,
            fullname_includes: ["/images/"],
            fullname_excludes: ["/images/thumb/", "/images/archive/", "/skins/", "/extensions/", "/resources/"],
            basename_excludes: [".htaccess", "README"]
          )

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
  
  def import_wordpress(import)
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
          
          tmpfile = Pathname.new(dir).join(file_name)

          Rails.logger.info{"ImportJob tmpfile: #{tmpfile}"}
          
          if ifile.file_content_type == "application/gzip"
            execute_command("gunzip #{tmpfile}")
          end
          
          process_directory(
            import,
            storage,
            dir,
            dir,
            fullname_includes: ["wp-content/uploads"],
            fullname_excludes: [],
            basename_excludes: [
              "-1038x",
              "-300x",
              "-1024x",
              "-563x",
              "-768x",
              "-150x",
              "-672x",
              "-791x",
              "-232x",
              "-55x",
              "-50x",
              "-448x",
              "-72x",
              "-420x",
              "-114x",
              "-225x",
              "-496x",
              "-502x",
              "-491x",
              "-636x",
              "-648x",
              "-632x",
              "-557x",
              "-587x",
              "-667x",
              "-642x",
              "-374x",
              "-109x",
              "-800x",
              "-630x",
              "-595x",
              "-620x",
              "-594x",
              "-199x",
              "-165x",
              "-281x",
              "-635x",
              "-649x",
              "-592x",
              "-640x",
              "-537x",
              "-960x",
              "-209x",
              "-383x",
              "-224x",
              "-765x",
              "-1037x",
              "-647x",
              "-646x",
              "-351x",
              "-272x",
              "-622x",
              "-631x",
              "-430x",
              "-1000x",
              "-182x",
              "-513x",
              "-454x",
              "-200x",
              "-267x",
              "-610x",
              "-650x",
              "-1031x",
              "-578x",
              "-492x",
              "-487x",
              "-490x",
              "-413x",
              "-240x",
              "-562x",
              "-561x",
              "-486x",
              "-591x",
              "-624x",
              "-277x",
              "-625x",
              "-623x",
              "-493x",
              "-600x",
              "-616x",
              "-488x",
              "-495x",
              "-422x",
              "-494x",
              "-259x",
              "-602x",
              "-608x",
              "-214x",
              "-548x",
              "-489x",
              "-291x",
              "-664x",
              "-656x",
              "-603x",
              "-598x",
              "-625x",
              "-661x",
              "-575x",
              "-641x",
              "-146x",
              "-1003x",
              "-294x",
              "-1021x",
              "-560x",
              "-588x",
              "-390x",
              "-215x",
            ]
          )

          uploads_path = IdentityFile.uploads_path
          
          storage[:uploads].each do |upload|
            uploadname = Pathname.new(upload).basename.to_s
            newfilepath = uploads_path + IdentityFile.name_to_random(name: uploadname, prefix: "WPU")
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
            append_message(import, "Processing SQL file #{sqlfile}")
            statements = File.read(sqlfile).split(/;$/)
            
            posts = {}
            
            statements.each do |statement|
              statement.lstrip!
              if statement.start_with?("INSERT INTO `wp_posts`")
                rows = Myp.parse_sql_insert(statement)
                rows.each do |row|
                  if row[7] == "publish" && row[20] == "post"
                    posts[row[0]] = row
                  end
                end
              end
            end
            
            posts.each do |post_id, post|
              date_local = Date.strptime(post[14], "%Y-%m-%d %H:%M:%S")
              
              pagename = post[5]

              # https://github.com/xijo/reverse_markdown
              #content_markdown = ReverseMarkdown.convert(post[4], unknown_tags: :pass_through, github_flavored: true)

              markdown = Myp.html_to_markdown(
                post[4],
                image_prefix: "/blogs/#{blog.id}/uploads/",
                thumbnails_prefix: "/blogs/#{blog.id}/upload_thumbnails/",
              )
              
              blog_post = BlogPost.create!(
                blog_post_title: pagename,
                post: markdown,
                import_original: post[4],
                edit_type: BlogPost::EDIT_TYPE_TEXT,
                post_date: date_local,
              )
              
              append_message(import, "Imported blog post [#{pagename}](/blogs/#{blog.id}/blog_posts/#{blog_post.id})")
              
              blog.blog_posts << blog_post
            end
          end
        end
      end
      
      blog.save!
    end
  end
  
  def process_directory(import, storage, dir, root_path, fullname_includes: [], fullname_excludes: [], basename_excludes: [])
    tmpfiles = execute_command("find #{dir}/ -type f").split("\n")
    
    tmpfiles.each do |f|
      fullfname = f.to_s
      fname = Pathname.new(f).basename.to_s
      
      Rails.logger.debug{"ImportJob found file: #{f}"}
      
      if fname.end_with?(".sql")
        Rails.logger.info{"ImportJob sql #{f}"}
        storage[:sqlfiles] = storage[:sqlfiles] + [f]
      elsif fname.end_with?(".tar")
        childdir = Pathname.new(dir).join("#{fname}_expanded")
        Dir.mkdir(childdir)
        Rails.logger.info{"ImportJob made directory: #{childdir}"}
        execute_command("mv \"#{f}\" \"#{childdir}\" && cd \"#{childdir}\" && tar xvf \"#{fname}\" && rm \"#{fname}\"")
        process_directory(
          import,
          storage,
          childdir,
          root_path,
          fullname_includes: fullname_includes,
          fullname_excludes: fullname_excludes,
          basename_excludes: basename_excludes,
        )
      elsif fullname_includes.any?{|x| !fullfname.index(x).nil? } && fullname_excludes.all?{|x| fullfname.index(x).nil? } && basename_excludes.all?{|x| fullfname.index(x).nil? }
        Rails.logger.info{"ImportJob matched file #{f}"}
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
