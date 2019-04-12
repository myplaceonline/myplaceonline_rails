class ImportJob < ApplicationJob
  def do_perform(*args)

    ExecutionContext.stack do
      
      job_context = args.shift
      import_job_context(job_context)

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
                
                import_mediawiki(import)
              when Import::IMPORT_TYPE_WORDPRESS
                Rails.logger.info{"ImportJob wordpress"}
                
                import_wordpress(import)
                
              when Import::IMPORT_TYPE_23ANDMEDNA
                Rails.logger.info{"ImportJob 23andme"}
                
                import_23andme(import)
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
              
              Myp.warn("ImportJob error", e)
            end
          end

          Rails.logger.info{"Finished ImportJob"}
        end
      end
    end
  end
  
  def append_message(import, message)
    Rails.logger.debug{"ImportJob.append_message #{message}".green}
    import.import_progress = "#{import.import_progress}\n* _#{User.current_user.time_now}_: #{message}"
    import.save!
  end
  
  def import_mediawiki(import)
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
            execute_command(command_line: "gunzip #{tmpfile.to_s}")
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
            FileUtils.chmod("a=rw", newfilepath)
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
            execute_command(command_line: "gunzip #{tmpfile.to_s}")
          end
          
          process_directory(
            import,
            storage,
            dir,
            dir,
            fullname_includes: ["wp-content/uploads"],
            fullname_excludes: [],
            basename_excludes: []
          )

          uploads_path = IdentityFile.uploads_path
          
          storage[:uploads].each do |upload|
            Rails.logger.debug{"ImportJob import_wordpress upload: #{upload}"}
            upload_pathname = Pathname.new(upload)
            uploadname = upload_pathname.parent.parent.basename.to_s + "_" + upload_pathname.basename.to_s
            newfilepath = uploads_path + IdentityFile.name_to_random(name: uploadname, prefix: "WPU")
            FileUtils.cp(upload, newfilepath)
            FileUtils.chmod("a=rw", newfilepath)
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
              date_created_local = Date.strptime(post[2], "%Y-%m-%d %H:%M:%S")
              date_modified_local = Date.strptime(post[14], "%Y-%m-%d %H:%M:%S")
              
              pagename = post[5]

              # https://github.com/xijo/reverse_markdown
              #content_markdown = ReverseMarkdown.convert(post[4], unknown_tags: :pass_through, github_flavored: true)

              markdown = Myp.html_to_markdown(
                post[4],
                image_prefix: "/blogs/#{blog.id}/uploads/#{date_created_local.year}_",
                thumbnails_prefix: "/blogs/#{blog.id}/upload_thumbnails/#{date_created_local.year}_",
              )
              
              blog_post = BlogPost.create!(
                blog_post_title: pagename,
                post: markdown,
                import_original: post[4],
                edit_type: BlogPost::EDIT_TYPE_TEXT,
                post_date: date_created_local,
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
    tmpfiles = execute_command(command_line: "find #{dir}/ -type f").split("\n")
    
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
        
        execute_command(command_line: "mv \"#{f}\" \"#{childdir}\" && cd \"#{childdir}\" && tar xvf \"#{fname}\" && rm \"#{fname}\"")
        
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

  def import_23andme(import)
    if import.import_files.length == 0
      raise "No import files found"
    elsif import.import_files.length > 1
      raise "Too many import files found"
    end
    
    dna_analysis = DnaAnalysis.where(import_id: import.id).take!
    dna_analysis.reference_genome = nil
    
    GenotypeCall.where(dna_analysis: dna_analysis).delete_all
    
    file = import.import_files[0].identity_file
    
    append_message(import, "File content type: #{file.file_content_type}")
    
    if file.file_content_type != "application/zip"
      raise "Invalid content type #{file.file_content_type}. Expecting application/zip"
    end
    
    Myp.mktmpdir do |dir|
      Rails.logger.debug{"ImportJob.import_23andme temp dir: #{dir}"}
      
      file_name = file.file_file_name.gsub("/", "").gsub("..", "")
      
      file.copy("#{dir}/#{file_name}")
      
      tmpfile = Pathname.new(dir).join(file_name)

      Rails.logger.debug{"ImportJob.import_23andme tmpfile: #{tmpfile}"}
      
      execute_command(command_line: "unzip #{tmpfile.to_s}", current_directory: dir)
      
      FileUtils.rm("#{tmpfile.to_s}")

      tmpfiles = execute_command(command_line: "find #{dir}/ -type f").split("\n")
      
      tmpfiles.each do |f|
        fullfname = f.to_s
        fname = Pathname.new(f).basename.to_s
        
        Rails.logger.debug{"ImportJob.import_23andme found file: #{f}"}
        
        if fname.end_with?(".txt")
          File.foreach(f).with_index do |line, line_num|
            #Rails.logger.debug{"ImportJob.import_23andme #{line_num}: #{line}"}
            process_dna(line, line_num, dna_analysis, import.identity_id)
          end
        end
      end
    end
    
    if dna_analysis.reference_genome.nil?
      raise "Could not find reference genome identifier"
    end
  end
  
  # Fields are TAB-separated
  # Each line corresponds to a single SNP.  For each SNP, we provide its identifier 
  # (an rsid or an internal id), its location on the reference human genome, and the 
  # genotype call oriented with respect to the plus strand on the human reference sequence.
  # We are using reference human assembly build 37 (also known as Annotation Release 104).
  # Note that it is possible that data downloaded at different times may be different due to ongoing 
  # improvements in our ability to call genotypes. More information about these changes can be found at:
  # https://you.23andme.com/p/752b1b71fb97f3aa/tools/data/download/
  # 
  # More information on reference human assembly build 37 (aka Annotation Release 104):
  # http://www.ncbi.nlm.nih.gov/mapview/map_search.cgi?taxid=9606
  #
  # Example:
  # rsid  chromosome      position        genotype
  # rs4477212       1       82154   AA
  # i701050 MT      16518   G
  #
  # Background
  # https://customercare.23andme.com/hc/en-us/articles/115004459928-Raw-Data-Technical-Details
  def process_dna(line, line_num, dna_analysis, identity_id)
    if line_num < 20 && line.starts_with?("# We are using reference human assembly build")
      line = line[46..-1]
      line = line[0..line.index(" ")-1]
      Rails.logger.debug{"ImportJob.process_dna updating reference_genome to #{line}, #{dna_analysis.import.import_status}"}
      dna_analysis.reference_genome = "GRCh" + line
      dna_analysis.save!
      Rails.logger.debug{"ImportJob.process_dna finished save"}
    elsif line.length > 0 && line[0] != '#'
      pieces = line.split(" ")
      if pieces.length != 4
        raise "Unexpected line #{line} only has #{pieces.length} components"
      end
      uid = pieces[0]
      chromosome = pieces[1]
      if chromosome == "MT"
        chromosome = -1
      elsif chromosome == "X"
        chromosome = -2
      elsif chromosome == "Y"
        chromosome = -3
      else
        chromosome = chromosome.to_i
      end
      position = pieces[2].to_i
      genotype = pieces[3]
      
      snp = Snp.where(snp_uid: uid).take
      if snp.nil?
        snp = Snp.create!(
          snp_uid: uid,
          chromosome: chromosome,
          position: position,
        )
      elsif snp.chromosome != chromosome
        raise "Unexpected SNP chromosome #{chromosome} for #{snp.inspect}"
      elsif snp.position != position
        raise "Unexpected SNP position #{position} for #{snp.inspect}"
      end
      
      variant1 = GenotypeCall.letter_to_type(genotype[0])
      variant2 = nil
      if genotype.length == 2
        variant2 = GenotypeCall.letter_to_type(genotype[1])
      elsif genotype.length > 2
        raise "Unknown genotype #{genotype} for #{line}"
      end
      
      GenotypeCall.create!(
        snp: snp,
        variant1: variant1,
        variant2: variant2,
        dna_analysis: dna_analysis,
        # https://customercare.23andme.com/hc/en-us/articles/115004459928-Raw-Data-Technical-Details#strandedness
        orientation: GenotypeCall::ORIENTATION_POSITIVE,
        identity_id: identity_id,
      )
    end
  end
  
  def execute_command(command_line:, current_directory: nil)
    Rails.logger.debug{"ImportJob executing: #{command_line}"}
    child = Myp.spawn(command_line: command_line, current_directory: current_directory)
    Rails.logger.debug{"ImportJob result: #{child.out}"}
    child.out
  end
end
