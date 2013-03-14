module Services
  class InvoiceBulkActionsService
    attr_reader :invoices, :invoice_ids, :options, :action_to_perform

    def initialize(options)
      actions_list = %w(archive destroy recover_archived recover_deleted send payment)
      @options = options
      @action_to_perform = actions_list.map{|action| action if @options[action]}.compact.first #@options[:commit]
      @invoice_ids = @options[:invoice_ids]
      @invoices = ::Invoice.multiple(@invoice_ids)
      @current_user = @options[:current_user]
    end

    def perform
      #TODO: for send_invoices the value for action_to_perform is 'send', need to take care of that
      #the above 'TODO:' has been taken care of in a bit ugly way
      #TODO now: do some makeup :)
      return method(@action_to_perform == 'send' ? 'send_invoices' : @action_to_perform).call.merge({invoice_ids: @invoice_ids, action_to_perform: @action_to_perform})
    end

    def archive
      @invoices.map(&:archive)
      prepare_result("invoices_archived").merge({action: "archived"})
    end

    def destroy
      invoices_with_payments = @invoices.select { |invoice| invoice.has_payment? }

      (@invoices - invoices_with_payments).map(&:destroy)

      action = invoices_with_payments.present? ? "invoices_with_payments" : "deleted"
      prepare_result("invoices_deleted").merge({action: action, invoices_with_payments: invoices_with_payments})
    end

    def recover_archived
      @invoices.map(&:unarchive)
      prepare_result(nil).merge({action: "recovered from archived"})
    end

    def recover_deleted
      @invoices.only_deleted.map { |invoice| invoice.recover; invoice.unarchive }
      invoices = ::Invoice.only_deleted.page(@options[:page]).per(@options[:per])
      {invoices: invoices, action: "recovered from deleted"}
    end

    def send_invoices
      @invoices.map { |invoice| invoice.update_attribute(:status, "sent") if send_invoice_to_client(invoice) }
      prepare_result(nil).merge({action: "sent"})
    end

    def payment
      action = @invoices.where(status: 'paid').present? ? "paid_invoices" : "enter_payment"
      {action: action}
    end

    private

    def send_invoice_to_client(invoice)
      InvoiceMailer.delay.new_invoice_email(invoice.client, invoice, invoice.encrypted_id, @current_user)
    end

    def prepare_result(message_helper)
      invoices = ::Invoice.unarchived.page(@options[:page]).per(@options[:per])
      #message = InvoicesController.helpers.send(message_helper, @invoice_ids) if @invoice_ids.present? && message_helper #rescue message = "#{message_helper}: #{}"
      {invoices: invoices}
    end
  end
end
