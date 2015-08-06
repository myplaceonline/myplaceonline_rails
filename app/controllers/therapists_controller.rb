class TherapistsController < MyplaceonlineController
  def model
    Therapist
  end
  
  def self.param_names
    [
      :name,
      :notes,
      therapist_conversations_attributes: [
        :id,
        :_destroy,
        :conversation,
        :conversation_date
      ],
      therapist_phones_attributes: [
        :id,
        :_destroy,
        :number,
        :phone_type
      ],
      therapist_emails_attributes: [
        :id,
        :_destroy,
        :email
      ],
      therapist_locations_attributes: [
        :id,
        :_destroy,
        location_attributes: LocationsController.param_names + [:id]
      ]
    ]
  end

  protected

    def sorts
      ["lower(therapists.name) ASC"]
    end

    def obj_params
      params.require(:therapist).permit(
        TherapistsController.param_names
      )
    end
end
