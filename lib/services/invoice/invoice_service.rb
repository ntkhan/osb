module Services
  #invoice related business logic will go here
  class InvoiceService

    # build a new invoice object
    def self.build_new_invoice(params)
      if params[:invoice_for_client]
        invoice = Invoice.new({:invoice_number => Invoice.get_next_invoice_number(nil), :invoice_date => Date.today, :client_id => params[:invoice_for_client]})
        3.times { invoice.invoice_line_items.build() }
      elsif params[:id]
        invoice = Invoice.find(params[:id]).use_as_template
        invoice.invoice_line_items.build()
      else
        invoice = Invoice.new({:invoice_number => Invoice.get_next_invoice_number(nil), :invoice_date => Date.today})
        3.times { invoice.invoice_line_items.build() }
      end
      invoice
    end

    # invoice bulk actions
    def self.perform_bulk_action(params)
      Services::InvoiceBulkActionsService.new(params).perform
    end

    def self.get_invoice_for_preview(encrypted_invoice_id)
      invoice_id = OSB::Util::decrypt(encrypted_invoice_id).to_i rescue invoice_id = nil
      invoice = Invoice.find_by_id(invoice_id)
      return nil if invoice.blank?
      invoice.viewed!
      invoice
    end

    def self.dispute_invoice(invoice_id, dispute_reason, current_user)
      invoice = Invoice.find_by_id(invoice_id)
      return nil if invoice.blank?
      invoice.disputed!
      InvoiceMailer.dispute_invoice_email(current_user, invoice, dispute_reason).deliver
    end

    def self.delete_invoices_with_payments(invoices_ids, convert_to_credit, )
      ids = params[:invoice_ids]
      Invoice.delete_invoices_with_payments(ids, !params[:convert_to_credit].blank?)
    end
  end
end