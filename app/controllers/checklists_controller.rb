class ChecklistsController < MyplaceonlineController
  def model
    Checklist
  end

  def display_obj(obj)
    obj.display
  end

  def generate
    set_obj
    
    @all_items = Array.new
    @obj.pre_checklist_references.each do |x|
      @all_items.concat(x.checklist.all_checklist_items)
    end
    @all_items.concat(@obj.all_checklist_items)
    @obj.post_checklist_references.each do |x|
      @all_items.concat(x.checklist.all_checklist_items)
    end
    
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
        ],
        checklist_references_attributes: [
          :id,
          :_destroy,
          :pre_checklist,
          checklist_attributes: [
            :id,
            :_destroy
          ]
        ]
      )
    end
end
