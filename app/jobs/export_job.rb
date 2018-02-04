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
              export.save!
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
      
      path = "#{export.parameter}/?security_token=#{export.security_token.security_token_value}"
      suffix = ".html"
      outname = "index"
      outname = outname.gsub(/[^a-zA-Z0-9,_\-]/, "")
      outfile = Pathname.new(dir).join(outname + suffix).to_s
      
      Rails.logger.debug{"ExportJob uploads_path: #{path}, outfile: #{outfile}"}
      
      execute_command(command_line: "curl --silent --output #{outfile} #{path}", current_directory: dir)
      
      output_name = "export_#{User.current_user.time_now.strftime("%Y%m%dT%H%M%S")}_"
      
      output_zip = uploads_path + IdentityFile.name_to_random(name: ".zip", prefix: output_name)

      Rails.logger.debug{"ExportJob output_zip: #{output_zip}"}
      
      stdout = execute_command(command_line: "zip -r #{output_zip} *", current_directory: dir)

      Rails.logger.debug{"ExportJob stdout: #{stdout}"}
    end
  end
  
  def execute_command(command_line:, current_directory: nil)
    Rails.logger.debug{"ExportJob executing: #{command_line}"}
    child = Myp.spawn(command_line: command_line, current_directory: current_directory)
    Rails.logger.debug{"ExportJob result: #{child.out}"}
    child.out
  end
end
