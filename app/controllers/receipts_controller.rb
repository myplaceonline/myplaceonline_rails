class ReceiptsController < MyplaceonlineController
  def may_upload
    true
  end

  protected
    def insecure
      true
    end

    def sorts
      ["receipts.receipt_time DESC"]
    end

    def obj_params
      params.require(:receipt).permit(
        :receipt_name,
        :receipt_time,
        :amount,
        :notes,
        receipt_files_attributes: [
          :id,
          :_destroy,
          identity_file_attributes: [
            :id,
            :file,
            :notes
          ]
        ]
      )
    end
end
