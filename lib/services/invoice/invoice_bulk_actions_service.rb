module Services
  class InvoiceBulkActionsService
    def initialize(options)
      @options ||= options
      @action_to_perform = @options[:commit]
      @invoice_ids = @ptions[:invoice_ids]
    end

    def perform
      return method(@action_to_perform).call
    end

    def archive
      Invoice.multiple(@invoice_ids).map(&:archive)

      invoices = Invoice.unarchived.page(params[:page]).per(params[:per])
      action = "archived"
      message = invoices_archived(ids) unless @invoice_ids.blank?
      {invoice: invoices, action: action, message: message}
    end

    def destroy
      invoices_list = Invoice.multiple(@invoice_ids)
      invoices_with_payments = invoices_list.select{|invoice| invoice.has_payment?}
      (invoices_list - invoices_with_payments).map(&:destroy)

      invoices = Invoice.unarchived.page(params[:page]).per(params[:per])
      action = "deleted"
      action = "invoices_with_payments" unless invoices_with_payments.blank?
      message = invoices_deleted(@invoice_ids) unless @invoice_ids.blank?
      {invoice: invoices, action: action, message: message, invoices_with_payments: invoices_with_payments}
    end

    def recover_archived

    end

    def recover_deleted

    end

    def send_invoice

    end

    def enter_payment

    end
  end
end
