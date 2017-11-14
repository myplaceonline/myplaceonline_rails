class UpdateMypletsJob < ApplicationJob
  def perform(*args)
    
    Rails.logger.info{"Started UpdateMypletsJob args: #{args}"}
    
    ExecutionContext.stack do

      job_context = args.shift
      import_job_context(job_context)

      Chewy.strategy(:atomic) do
        
        website_domain = args[0]
        
        website_domain_myplets_count = website_domain.website_domain_myplets.count
        
        Rails.logger.debug{"UpdateMypletsJob myplets: #{website_domain_myplets_count}"}
        
        website_domain_myplets = website_domain.website_domain_myplets.to_a
        
        Rails.logger.debug{"UpdateMypletsJob user: #{MyplaceonlineExecutionContext.user}, identity: #{MyplaceonlineExecutionContext.identity}"}
        
        Identity.where(website_domain: website_domain).each do |identity|
          
          MyplaceonlineExecutionContext.do_full_context(identity.user, identity) do
            
            Rails.logger.debug{"UpdateMypletsJob user: #{MyplaceonlineExecutionContext.user}, identity: #{MyplaceonlineExecutionContext.identity}"}
            
            myplets = Myplet.where(identity: identity).order(:x_coordinate, :y_coordinate)
            myplets_count = myplets.count
            
            if website_domain_myplets_count != myplets_count
              
              new_myplets = website_domain_myplets.dup

              Rails.logger.debug{"UpdateMypletsJob counts do not match: #{myplets_count}"}
              
              new_myplets.delete_if{|new_myplet| !myplets.index{|myplet| new_myplet.matches?(myplet) }.nil? }
              
              y_coordinate = myplets.count
              
              new_myplets.each do |new_myplet|
                
                Rails.logger.debug{"UpdateMypletsJob creating new myplet #{new_myplet} at #{y_coordinate}"}
                
                new_myplet.create_for_identity(identity, y_coordinate: y_coordinate)
                
                y_coordinate = y_coordinate + 1
              end

            end
            
          end
          
        end
        
      end
    end

    Rails.logger.info{"Ended UpdateMypletsJob"}
  end
end
