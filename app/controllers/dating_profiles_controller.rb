class DatingProfilesController < MyplaceonlineController
  def may_upload
    true
  end

  protected
    def insecure
      true
    end

    def sorts
      ["lower(dating_profiles.dating_profile_name) ASC"]
    end

    def obj_params
      params.require(:dating_profile).permit(
        :dating_profile_name,
        :about_me,
        :looking_for,
        :movies,
        :books,
        :music,
        :notes,
        dating_profile_files_attributes: FilesController.multi_param_names
      )
    end
end
