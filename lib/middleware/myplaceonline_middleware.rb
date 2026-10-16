require_relative "../myputils/dynamic_cookie_options.rb"

class MyplaceonlineMiddleware
  def initialize(app)
    @app = app
  end
  
  def call(env)
    
    Rails.logger.debug{"MyplaceonlineMiddleware call processing request"}
    
    # Clear the contexts just in case somehow it wasn't cleared from the last request
    ExecutionContext.clear
    
    ExecutionContext.stack do
      
      query_string = env["rack.request.query_string"]
      parsed_query_string = Rack::Utils.parse_nested_query(query_string)
      
      # If the request comes in with a security token, then log that user in
      security_token = parsed_query_string["security_token"]
      
      Rails.logger.debug{"MyplaceonlineMiddleware parsed_query_string: #{parsed_query_string}"}
      
      user_agent = env["HTTP_USER_AGENT"]
      if !user_agent.blank?
        user_agent = user_agent.downcase
        if user_agent.include?("myplaceonline bot (read-only)")
          Rails.logger.debug{"MyplaceonlineMiddleware setting offline true because of User-Agent"}
          MyplaceonlineExecutionContext.offline = true
        end
      end
      
      if parsed_query_string["display_offline"].is_true?
          Rails.logger.debug{"MyplaceonlineMiddleware setting offline true because of display_offline"}
        MyplaceonlineExecutionContext.offline = true
      end
      
      if !security_token.blank?
        
        Rails.logger.debug{"MyplaceonlineMiddleware call security_token: #{security_token}"}
        
        token_user = nil
        token_password = nil
        
        tokens = SecurityToken.where(security_token_value: security_token).to_a
        if tokens.length == 1
          token = tokens[0]
          token_user = token.identity.user
          token_password = token.password
          
          if !token.available_uses.nil?
            token.available_uses = token.available_uses - 1
            MyplaceonlineExecutionContext.do_full_context(token_user, token.identity) do
              if token.available_uses <= 0
                token.destroy!
              else
                token.save!
              end
            end
          end
        elsif tokens.length > 1
          raise "Not implemented"
        end
        
        if !token_user.nil?
          scope = Devise::Mapping.find_scope!(:user)
          env["warden"].set_user(token_user, { scope: scope })
          if !token_password.blank?
            MyplaceonlineExecutionContext.persistent_user_store = InMemoryPersistentUserStore.new
            Myp.persist_password(token_password)
          end
        end
      end

      # We could load up the user from warden, but that would mean we'd do a SQL request on all requests including
      # images, etc.
      
      # user = env["warden"].user
      
      # Instead, we just grab the user ID from warden's cookie
      warden_user_key = env["rack.session"]["warden.user.user.key"]
      user_id = warden_user_key.nil? ? -1 : warden_user_key[0][0]
      
      MyplaceonlineExecutionContext.request_uri = env["REQUEST_URI"]
      
      Rails.logger.info{"MyplaceonlineMiddleware request with user ID #{user_id} for #{MyplaceonlineExecutionContext.host} #{MyplaceonlineExecutionContext.request_uri}"}

      # Debug
      #awesome_print(env)
      
      Myp.log_response_time(
        name: "MyplaceonlineMiddleware.call",
        uri: env["REQUEST_URI"],
        request_id: env["action_dispatch.request_id"],
        user_id: user_id
      ) do
      
        # Save off any per-request info:
        
        # "SERVER_SOFTWARE" => "thin 1.7.1 codename Muffin Mode",
        # "SERVER_NAME" => "localhost",
        # "REQUEST_METHOD" => "GET",
        # "REQUEST_PATH" => "/",
        # "PATH_INFO" => "/",
        # "REQUEST_URI" => "/",
        # "HTTP_VERSION" => "HTTP/1.1",
        # "HTTP_HOST" => "localhost:3000",
        # "HTTP_USER_AGENT" => "curl/7.51.0",
        # "HTTP_ACCEPT" => "*/*",
        # "GATEWAY_INTERFACE" => "CGI/1.2",
        # "SERVER_PORT" => "3000",
        # "QUERY_STRING" => "",
        # "SERVER_PROTOCOL" => "HTTP/1.1",
        # "SCRIPT_NAME" => "",
        # "REMOTE_ADDR" => "127.0.0.1",
        # "ORIGINAL_FULLPATH" => "/",
        # "ORIGINAL_SCRIPT_NAME" => "",
        
        host = env["HTTP_HOST"]
        if host.nil?
          host = ""
        end
        if !host.index(':').nil?
          host = host.gsub(/:\d+$/, "")
        end
        if host =~ /localhost$/ || host == "127.0.0.1"
          host = ""
        end
        
        if !parsed_query_string["emulate_host"].blank?
          host = parsed_query_string["emulate_host"]
          Rails.logger.info{"MyplaceonlineMiddleware call Emulated host: #{host}"}
        end
        
        # See also https://github.com/knu/ruby-domain_name/
        if host.starts_with?("www.")
          host = host[4..-1]
        end
        
        # Internal, direct requests from things like Apache Bench to initialize a server:
        i = host.index("-internal.myplaceonline.com")
        if !i.nil?
          host = host[i + 10..-1]
        end

        MyplaceonlineExecutionContext.host = host
        MyplaceonlineExecutionContext.query_string = query_string
        MyplaceonlineExecutionContext.cookie_hash = env["rack.request.cookie_hash"]

        if !MyplaceonlineExecutionContext.cookie_hash.nil?
          sessioncookie = MyplaceonlineExecutionContext.cookie_hash["rails_session"]
          if !sessioncookie.nil?
            Rails.logger.info{"MyplaceonlineMiddleware request with session #{sessioncookie}"}
          end
          sessioncookieremember = MyplaceonlineExecutionContext.cookie_hash["rails_session_remember"]
          if !sessioncookieremember.nil?
            Rails.logger.info{"MyplaceonlineMiddleware request with remember #{sessioncookieremember}"}
          end
        end
        
        Rails.logger.debug{"MyplaceonlineMiddleware setting cookie domain = #{DynamicCookieOptions.cookie_domain}"}
        env["rack.session.options"][:domain] = DynamicCookieOptions.cookie_domain

        if parsed_query_string["current_identity_id"] != "-1"
          
          if !parsed_query_string["current_identity_id"].blank?
            cii = parsed_query_string["current_identity_id"].to_i
            user = env["warden"].user
            i = user.identities.index{|x| x.id == cii}
            if !i.nil?
              user.change_default_identity(user.identities[i])
            else
              raise "Invalid identity"
            end
          end
          
          if !parsed_query_string["temp_identity_id"].blank?
            tii = parsed_query_string["temp_identity_id"].to_i
            user = env["warden"].user
            i = user.identities.index{|x| x.id == tii}
            if !i.nil?
              MyplaceonlineExecutionContext[:temp_identity_id] = tii
            else
              raise "Invalid identity"
            end
          end

          #Rails.logger.debug{"MyplaceonlineMiddleware.call setting context host: #{MyplaceonlineExecutionContext.host}, query_string: #{MyplaceonlineExecutionContext.query_string}, cookie_hash: #{Myp.debug_print(MyplaceonlineExecutionContext.cookie_hash)}"}

          appresult = @app.call(env)

          #Rails.logger.debug{"MyplaceonlineMiddleware.call after response env: #{Myp.debug_print(env)}"}

          responseCode = appresult[0]
          responseHeaders = appresult[1]
          responseBody = appresult[2] # e.g. ActionDispatch::Response::RackBody
          #Rails.logger.debug{appresult}

          Rails.logger.debug{"MyplaceonlineMiddleware.call sending response code #{responseCode}"}

          if false && !responseHeaders.nil? && responseHeaders.is_a?(Hash)
            responseHeaders.each_pair do |responseHeaderKey, responseHeaderValue|
              responseHeaderKeyLowercase = responseHeaderKey.downcase

              # The set cookie for the session happens after Rack Middleware
              #if responseHeaderKey == "set-cookie"
              #  Rails.logger.info{"MyplaceonlineMiddleware.call response Set-Cookie #{responseHeaderValue}"}
              #end
            end
          end

          #if !responseBody.nil? && responseBody.is_a?(ActionDispatch::Response::RackBody)
          #  begin
          #    innerResponse = responseBody.instance_variable_get(:@response)
          #    if !innerResponse.nil? && innerResponse.is_a?(ActionDispatch::Response)
          #      Rails.logger.debug{innerResponse.cookies}
          #    end
          #  rescue Exception
          #  end
          #end

          appresult
        else
          request = ActionDispatch::Request.new(env)
          
          # "The response tuple is an Array of three elements, which are:
          #  the HTTP status, the headers, and the response body."
          # 
          # "The Body is typically an Array of String values"
          # https://rack.github.io/rack/main/SPEC_rdoc.html#label-The+Response
          [
            302,
            {
              # "Header keys must not contain uppercase ASCII characters (A-Z)."
              # https://rack.github.io/rack/main/SPEC_rdoc.html#label-The+Response
              "location": "#{request.protocol}#{request.host_with_port}/identities/new"
            },
            [""],
          ]
        end
      end
    end
  end
  
  def each(&block)
  end
end
