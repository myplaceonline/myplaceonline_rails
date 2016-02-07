class ContactsController < MyplaceonlineController
  def may_upload
    true
  end
  
  def index
    @contact_type = params[:contact_type]
    if !@contact_type.blank?
      @contact_type = @contact_type.to_i
    end
    super
  end

  def self.param_names
    [
      :id,
      :_destroy,
      :contact_type,
      conversations_attributes: [
        :id,
        :conversation,
        :conversation_date,
        :_destroy
      ],
      contact_identity_attributes: [
        :id,
        :name,
        :nickname,
        :birthday,
        :notes,
        :likes,
        :gift_ideas,
        :ktn,
        :sex_type,
        :new_years_resolution,
        identity_phones_attributes: [
          :id,
          :number,
          :phone_type,
          :_destroy
        ],
        identity_emails_attributes: [:id, :email, :_destroy],
        identity_locations_attributes: [
          :id,
          :_destroy,
          location_attributes: LocationsController.param_names
        ],
        identity_drivers_licenses_attributes: [
          :id,
          :identifier,
          :expires,
          :region,
          :sub_region1,
          :_destroy,
          identity_file_attributes: [
            :id,
            :file,
            :_destroy
          ]
        ],
        identity_relationships_attributes: [
          :id,
          :relationship_type,
          :_destroy,
          contact_attributes: [
            :id,
            :_destroy
          ]
        ],
        identity_pictures_attributes: [
          :id,
          :_destroy,
          identity_file_attributes: [
            :id,
            :file,
            :notes
          ]
        ]
      ]
    ]
  end

  def self.reject_if_blank(attributes)
    attributes.all?{|key, value|
      if key == "contact_identity_attributes"
        value.all?{|key2, value2| value2.blank?}
      else
        value.blank?
      end
    }
  end

  protected

    def sorts
      ["lower(identities.name) ASC"]
    end

    def obj_params
      params.require(:contact).permit(
        ContactsController.param_names
      )
    end

    def all_additional_sql
      if @contact_type.blank?
        ""
      else
        "and contact_type = " + @contact_type.to_s
      end
    end

    # Join because we're sorting by identity name
    def all_joins
      :contact_identity
    end
    
    def all_includes
      :contact_identity
    end
end
