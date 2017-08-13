class BlogsController < MyplaceonlineController
  def may_upload
    true
  end

  protected
    def insecure
      true
    end

    def sorts
      ["lower(blogs.blog_name) ASC"]
    end

    def obj_params
      params.require(:blog).permit(
        :blog_name,
        :notes,
        blog_files_attributes: FilesController.multi_param_names,
      )
    end
end
