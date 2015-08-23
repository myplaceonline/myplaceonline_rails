class ContactsController < MyplaceonlineController
  def model
    Contact
  end
  
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
      :contact_type,
      conversations_attributes: [
        :id,
        :conversation,
        :conversation_date,
        :_destroy
      ],
      identity_attributes: [
        :id,
        :name,
        :nickname,
        :birthday,
        :notes,
        :likes,
        :gift_ideas,
        :ktn,
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
          {
            location_attributes: LocationsController.param_names + [:id]
          }
        ],
        identity_drivers_licenses_attributes: [
          :id,
          :identifier,
          :expires,
          :region,
          :sub_region1,
          :_destroy,
          {
            identity_file_attributes: [
              :id,
              :file,
              :_destroy
            ]
          }
        ],
        identity_relationships_attributes: [
          :id,
          :relationship_type,
          :_destroy,
          {
            contact_attributes: [
              :id,
              :_destroy
            ]
          }
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
      if key == "identity_attributes"
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

    def all
      if @contact_type.blank?
        model.joins(:identity).where(
          owner_id: current_user.primary_identity.id
        )
      else
        model.joins(:identity).where(
          owner_id: current_user.primary_identity.id,
          contact_type: @contact_type
        )
      end
    end
end
