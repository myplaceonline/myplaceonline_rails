class ChecklistsController < MyplaceonlineController
  def show
    @all_items = find_items
    super
  end

  def show_created_updated
    false
  end

  protected
  
    def find_items
      result = Array.new
      @obj.pre_checklist_references.each do |x|
        if !x.checklist.nil?
          result.concat(x.checklist.all_checklist_items)
        end
      end
      result.concat(@obj.all_checklist_items)
      @obj.post_checklist_references.each do |x|
        if !x.checklist.nil?
          result.concat(x.checklist.all_checklist_items)
        end
      end
      result
    end
    
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
