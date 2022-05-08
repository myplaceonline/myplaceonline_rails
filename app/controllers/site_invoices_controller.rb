#require "paypal-sdk-rest"

class SiteInvoicesController < MyplaceonlineController
#  include PayPal::SDK::REST

  def use_bubble?
    true
  end
  
  def bubble_text(obj)
    Myp.get_select_name(obj.invoice_status, SiteInvoice::INVOICE_STATUSES)
  end

  def pay
    set_obj
    
    if params[:payment_type] == SiteInvoice::PAYMENT_TYPE_PAYPAL.to_s
      
      website_domain = Myp.website_domain
      
      paypal_web_profile = PaypalWebProfile.where(website_domain: website_domain).take
      
      if paypal_web_profile.nil?
        web_profile = WebProfile.new({
          name: website_domain.display,

          # https://developer.paypal.com/docs/api/payment-experience/#definition-presentation
          presentation: {
            brand_name: website_domain.display,
            logo_image: "#{Myp.root_url}/api/header_icon.png",
            locale_code: "US"
          },

          # https://developer.paypal.com/docs/api/payment-experience/#definition-input_fields
          input_fields: {
            allow_note: true,
            no_shipping: 1
          }
        })
        if web_profile.create
          
          if !web_profile.error.nil? && web_profile.error["name"] == "VALIDATION_ERROR"
            web_profile = WebProfile.get_list.find{|x| x.name == website_domain.display}
          end
          
          paypal_web_profile = PaypalWebProfile.create!(
            website_domain_id: website_domain.id,
            profile_id: web_profile.id
          )
        else
          raise web_profile.error
        end
      end
      
      # https://developer.paypal.com/docs/api/payments/#definition-payment
      payment = Payment.new({
        intent: "sale",
        payer: {
          payment_method: "paypal"
        },
        experience_profile_id: paypal_web_profile.profile_id,
        redirect_urls: {
          return_url: site_invoice_paypal_complete_url(@obj),
          cancel_url: site_invoice_pay_url(@obj)
        },
        transactions: [
          # https://developer.paypal.com/docs/api/payments/#definition-transaction
          {
            reference_id: @obj.id.to_s,
            item_list: {
              items: [
                # https://developer.paypal.com/docs/api/payments/#definition-item
                {
                  name: @obj.display,
                  sku: @obj.id,
                  price: @obj.next_charge.to_s,
                  currency: "USD",
                  quantity: 1
                }
              ]
            },
            amount: {
              total: @obj.next_charge.to_s,
              currency: "USD"
            },
            description: @obj.display,
          }
        ]
      })
      
      if payment.create
        redirect_to(
          payment.links.find{|x| x.method == "REDIRECT"}.href
        )
      else
        raise payment.error
      end
    end
  end
  
  def pay_other
    set_obj
  end

  def paypal_complete
    set_obj

    # https://developer.paypal.com/docs/integration/direct/payments/paypal-payments/
    payerID = params[:PayerID]
    payment_id = params[:paymentId]
    payment = Payment.find(payment_id)
    if payment.execute(payer_id: payerID)
      total_paid = payment.transactions[0].amount.total.to_f
      if @obj.total_paid.nil?
        @obj.total_paid = 0.0
      end
      @obj.total_paid = @obj.total_paid + total_paid
      if @obj.payment_notes.nil?
        @obj.payment_notes = ""
      end
      @obj.payment_notes = @obj.payment_notes + User.current_user.time_now.to_s + "\n" + payment.inspect + "\n"
      if @obj.remaining <= 0
        @obj.invoice_status = SiteInvoice::INVOICE_STATUS_PAID
      end
      @obj.save!
      
      message = I18n.t("myplaceonline.site_invoices.paid", amount: Myp.number_to_currency(total_paid))
      redirect_path = obj_path
      model_paid_result = self.model_paid
      if !model_paid_result.nil?
        redirect_path = model_paid_result[:redirect_path]
        if !model_paid_result[:message].blank?
          message = model_paid_result[:message]
        end
      end
      model_obj = @obj.find_model_object
      if !model_obj.nil? && model_obj.respond_to?("paid")
        paid_result = model_obj.paid(@obj)
      end

      redirect_to(
        redirect_path,
        flash: {
          notice: message
        }
      )
    else
      raise "Could not complete PayPal transaction"
    end
  end
  
  def model_paid
    model_obj = @obj.find_model_object
    if !model_obj.nil? && model_obj.respond_to?("paid")
      model_obj.paid(@obj)
    else
      nil
    end
  end
  
  def mark_paid
    set_obj
    deny_nonadmin
    
    @obj.total_paid = @obj.invoice_amount
    @obj.invoice_status = SiteInvoice::INVOICE_STATUS_PAID
    @obj.save!
    
    self.model_paid
    
    redirect_to(obj_path, flash: { notice: I18n.t("myplaceonline.site_invoices.marked_paid") })
  end

  def footer_items_show
    result = []
    
    result << {
      title: I18n.t("myplaceonline.site_invoices.pay"),
      link: site_invoice_pay_path(@obj),
      icon: "shop"
    }
    
    if User.current_user.admin?
      result << {
        title: I18n.t("myplaceonline.site_invoices.mark_paid"),
        link: site_invoice_mark_paid_path(@obj),
        icon: "check"
      }
    end
    
    result + super
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
