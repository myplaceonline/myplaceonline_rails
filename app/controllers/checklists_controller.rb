class ChecklistsController < MyplaceonlineController
  def model
    Checklist
  end

  def display_obj(obj)
    obj.display
  end

  def generate
    set_obj
    respond_with(@obj)
  end

  protected
    def sorts
      ["lower(checklists.checklist_name) ASC"]
    end

    def obj_params
      params.require(:checklist).permit(
        :checklist_name,
        checklist_items_attributes: [
          :id,
          :checklist_item_name,
          :position,
          :_destroy
        ]
      )
    end
end
