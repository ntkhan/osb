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

    def self.encrypt(value_to_encrypt)
      secret = Digest::SHA1.hexdigest("osb-dey-lashkarey-jagh-mag-bill-sarey")
      e = ActiveSupport::MessageEncryptor.new(secret)
      Base64.encode64(e.encrypt_and_sign(value_to_encrypt))
    end

    def self.decrypt(value_to_decrypt)
      secret = Digest::SHA1.hexdigest("osb-dey-lashkarey-jagh-mag-bill-sarey")
      e = ActiveSupport::MessageEncryptor.new(secret)
      e.decrypt_and_verify(Base64.decode64(value_to_decrypt))
    end

  end
end