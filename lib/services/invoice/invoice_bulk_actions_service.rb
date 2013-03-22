module Services
  class InvoiceBulkActionsService
    attr_reader :invoices, :invoice_ids, :options, :action_to_perform

    def initialize(options)
      actions_list = %w(archive destroy recover_archived recover_deleted send payment)
      @options = options
      @action_to_perform = actions_list.map { |action| action if @options[action] }.compact.first #@options[:commit]
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
      {action: 'archived', invoices: get_invoices('unarchived')}
    end

    def destroy
      invoices_with_payments = @invoices.select { |invoice| invoice.has_payment? }

      (@invoices - invoices_with_payments).map(&:destroy)

      action = invoices_with_payments.present? ? 'invoices_with_payments' : 'deleted'
      {action: action, invoices_with_payments: invoices_with_payments, invoices: get_invoices('unarchived')}
    end

    def recover_archived
      @invoices.map(&:unarchive)
      {action: 'recovered from archived', invoices: get_invoices('archived')}
    end

    def recover_deleted
      @invoices.only_deleted.map { |invoice| invoice.recover; invoice.unarchive; invoice.change_status_after_recover }
      invoices = ::Invoice.only_deleted.page(@options[:page]).per(@options[:per])
      {action: 'recovered from deleted', invoices: get_invoices('only_deleted')}
    end

    def send_invoices
      @invoices.map { |invoice| invoice.update_attribute(:status, 'sent') if send_invoice_to_client(invoice) }
      {action: 'sent', invoices: get_invoices('unarchived')}
    end

    def payment
      action = @invoices.where(status: 'paid').present? ? 'paid invoices' : 'enter payment'
      {action: action, invoices: @invoices}
    end

    private

    def send_invoice_to_client(invoice)
      InvoiceMailer.delay.new_invoice_email(invoice.client, invoice, invoice.encrypted_id, @current_user)
    end

    private

    def get_invoices(invoice_filter)
      ::Invoice.send(invoice_filter).page(@options[:page]).per(@options[:per])
    end
  end
end
