class SiteInvoicesController < MyplaceonlineController
  def use_bubble?
    true
  end
  
  def bubble_text(obj)
    Myp.get_select_name(obj.invoice_status, SiteInvoice::INVOICE_STATUSES)
  end

  def pay
    set_obj
    
    if request.post?
      
      redirect_to(
        obj_path,
        #flash: { notice: I18n.t("myplaceonline.reputation_reports.reporter_contacted") }
      )
    end
  end

  def footer_items_show
    [
      {
        title: I18n.t("myplaceonline.site_invoices.pay"),
        link: site_invoice_pay_path(@obj),
        icon: "shop"
      },
    ] + super
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
