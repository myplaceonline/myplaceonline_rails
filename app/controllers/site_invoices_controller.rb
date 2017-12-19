class SiteInvoicesController < MyplaceonlineController
  skip_authorization_check :only => MyplaceonlineController::DEFAULT_SKIP_AUTHORIZATION_CHECK + [:static_page]

  def use_bubble?
    true
  end
  
  def bubble_text(obj)
    Myp.get_select_name(self.invoice_status, SiteInvoice::INVOICE_STATUSES)
  end

  protected
    def default_sort_direction
      "desc"
    end

    def additional_sorts
      [
        [I18n.t("myplaceonline.site_invoices.invoice_time"), default_sort_columns[0]]
      ]
    end

    def default_sort_columns
      ["site_invoices.invoice_time"]
    end

    def obj_params
      params.require(:site_invoice).permit(
        :notes,
      )
    end
end
