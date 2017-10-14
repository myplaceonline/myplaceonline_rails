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
    
    def additional_sorts
      [
        [I18n.t("myplaceonline.checklists.checklist_name"), default_sort_columns[0]]
      ]
    end

    def default_sort_columns
      ["lower(checklists.checklist_name)"]
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
