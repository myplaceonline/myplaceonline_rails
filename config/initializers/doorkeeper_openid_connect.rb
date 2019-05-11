Doorkeeper::OpenidConnect.configure do
  issuer "https://myplaceonline.com/"

  if !Rails.env.production? && !File.exist?("config/oidcsigning.pem")
    Myp.spawn(command_line: "openssl genpkey -algorithm RSA -out config/oidcsigning.pem -pkeyopt rsa_keygen_bits:4096")
  end
  signing_key = File.read("config/oidcsigning.pem")

  subject_types_supported [:public]

  resource_owner_from_access_token do |access_token|
    # Example implementation:
    User.find_by(id: access_token.resource_owner_id)
  end
  
  auth_time_from_resource_owner do |resource_owner|
    # Example implementation:
    resource_owner.current_sign_in_at
  end

  reauthenticate_resource_owner do |resource_owner, return_to|
    # Example implementation:
    store_location_for resource_owner, return_to
    # sign_out resource_owner
    # redirect_to new_user_session_url
  end

  subject do |resource_owner, application|
    # Example implementation:
    resource_owner.id

    # or if you need pairwise subject identifier, implement like below:
    # Digest::SHA256.hexdigest("#{resource_owner.id}#{URI.parse(application.redirect_uri).host}#{'your_secret_salt'}")
  end

  # Protocol to use when generating URIs for the discovery endpoint,
  # for example if you also use HTTPS in development
  # protocol do
  #   :https
  # end

  # Expiration time on or after which the ID Token MUST NOT be accepted for processing. (default 120 seconds).
  # expiration 600

  # Example claims:
  # claims do
  #   normal_claim :_foo_ do |resource_owner|
  #     resource_owner.foo
  #   end

  #   normal_claim :_bar_ do |resource_owner|
  #     resource_owner.bar
  #   end
  # end
  
  claims do
    claim :email do |resource_owner|
      resource_owner.email
    end

    claim :full_name do |resource_owner|
      resource_owner.display
    end
  end
end
