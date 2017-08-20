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
          import.import_progress = "* _#{User.current_user.time_now}_: Started"
          import.save!
          
          append_message(import, "Finished")

          import.import_status = Import::IMPORT_STATUS_IMPORTED
          import.save!
        end

        Rails.logger.info{"Finished ImportJob"}
      end
    end
  end
  
  def append_message(import, message)
    import.import_progress = "#{import.import_progress}\n* _#{User.current_user.time_now}_: #{message}"
    import.save!
  end
end
