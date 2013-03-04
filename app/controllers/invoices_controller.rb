class InvoicesController < ApplicationController
  before_filter :authenticate_user!, :except => [:preview, :invoice_pdf, :paypal_payments]
  protect_from_forgery :except => [:paypal_payments]
  # GET /invoices
  # GET /invoices.json
  layout :choose_layout
  include InvoicesHelper

  def index
    #per_page = params[:per]
    @invoices = Invoice.unarchived.page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.js
      #format.json { render json: @invoices }
    end
  end

  # GET /invoices/1
  # GET /invoices/1.json
  def show
    @invoice = Invoice.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
    end
  end

  def invoice_pdf
    # to be used in invoice_pdf view because it requires absolute path of image
    @images_path = "#{request.protocol}#{request.host_with_port}/assets"

    @invoice = Invoice.find(params[:id])
    render :layout => "pdf_mode"
  end

  def preview
    @id = decrypt(Base64.decode64(params[:inv_id])).to_i rescue @id = nil
    @id = decrypt(Base64.decode64(params[:inv_id])).to_i rescue @id = nil
    @invoice = @id.blank? ? nil : Invoice.find(@id)
    @invoice.update_attribute("status", "viewed") if @invoice.present? && @invoice.status == "sent"
  end

  # GET /invoices/new
  # GET /invoices/new.json
  def new
    if params[:invoice_for_client]
      @invoice = Invoice.new({:invoice_number => Invoice.get_next_invoice_number(nil), :invoice_date => Date.today, :client_id => params[:invoice_for_client]})
      3.times { @invoice.invoice_line_items.build() }
    elsif params[:id]
      @invoice = Invoice.find(params[:id]).use_as_template
      @invoice.invoice_line_items.build()
    else
      @invoice = Invoice.new({:invoice_number => Invoice.get_next_invoice_number(nil), :invoice_date => Date.today})
      3.times { @invoice.invoice_line_items.build() }
    end
    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @invoice }
    end
  end

  # GET /invoices/1/edit
  def edit
    @invoice = Invoice.find(params[:id])
    @invoice.invoice_date = @invoice.invoice_date.to_date
    @invoice.invoice_line_items.build()
  end

  # POST /invoices
  # POST /invoices.json
  def create
    @invoice = Invoice.new(params[:invoice])
    params[:save_as_draft] ? @invoice.status = "draft" : @invoice.status = "sent"
    respond_to do |format|
      if @invoice.save
        @invoice.notify(current_user, encrypt(@invoice.id))
        new_invoice_message = new_invoice(@invoice.id, params[:save_as_draft])
        redirect_to(edit_invoice_url(@invoice), :notice => new_invoice_message)
        return
      else
        format.html { render :action => "new" }
        format.json { render :json => @invoice.errors, :status => :unprocessable_entity }
      end
    end
  end

  def enter_single_payment
    invoice_ids = [params[:ids]]
    redirect_to({:action => "enter_payment", :controller => "payments", :invoice_ids => invoice_ids})
  end

  # PUT /invoices/1
  # PUT /invoices/1.json
  def update
    @invoice = Invoice.find(params[:id])
    response_to_client = params[:response_to_client]
     unless response_to_client.blank?
      @invoice.update_attribute("status","sent")
      InvoiceMailer.response_to_client(current_user, @invoice, response_to_client).deliver
     end
    respond_to do |format|
      if @invoice.update_attributes(params[:invoice])
        #format.html { redirect_to @invoice, :notice => 'Invoice was successfully updated.' }
        format.json { head :no_content }
        redirect_to({:action => "edit", :controller => "invoices", :id => @invoice.id}, :notice => 'Your Invoice has been updated successfully.')
        return
      else
        format.html { render :action => "edit" }
        format.json { render :json => @invoice.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /invoices/1
  # DELETE /invoices/1.json
  def destroy
    @invoice = Invoice.find(params[:id])
    @invoice.destroy

    respond_to do |format|
      format.html { redirect_to invoices_url }
      format.json { head :no_content }
    end
  end

  def unpaid_invoices
    @invoices = Invoice.where("status != 'paid' or status is null").all
    respond_to { |format| format.js }
  end

  def bulk_actions
    ids = params[:invoice_ids]
    if params[:archive]
      Invoice.archive_multiple(ids)
      @invoices = Invoice.unarchived.page(params[:page])
      @action = "archived"
      @message = invoices_archived(ids) unless ids.blank?
    elsif params[:destroy]
      @invoices_with_payments = Invoice.delete_multiple(ids)
      @invoices = Invoice.unarchived.page(params[:page])
      @action = "deleted"
      @action = "invoices_with_payments" unless @invoices_with_payments.blank?
      @message = invoices_deleted(ids) unless ids.blank?
    elsif params[:recover_archived]
      Invoice.recover_archived(ids)
      @invoices = Invoice.archived.page(params[:page])
      @action = "recovered from archived"
    elsif params[:recover_deleted]
      Invoice.recover_deleted(ids)
      @invoices = Invoice.only_deleted.page(params[:page])
      @action = "recovered from deleted"
    elsif params[:payment]
      @action = unless Invoice.paid_invoices(ids).present?
                  #Invoice.paid_full(ids)
                  "enter payment"
                else
                  "paid invoices"
                end
      #@invoices = Invoice.unarchived.page(params[:page])
    end

    respond_to { |format| format.js }
  end

  def undo_actions
    params[:archived] ? Invoice.recover_archived(params[:ids]) : Invoice.recover_deleted(params[:ids])
    @invoices = Invoice.unarchived.page(params[:page])
    respond_to { |format| format.js }
  end

  def filter_invoices
    @invoices = Invoice.filter(params)
  end

  def send_invoice
    @invoice = Invoice.find_by_id(params[:id])
    @invoice.send_invoice(current_user, encrypt(params[:id]))
    redirect_to(invoice_path(@invoice), :notice => "Invoice has been sent successfully")
  end

  def delete_invoices_with_payments
    ids = params[:invoice_ids]
    Invoice.delete_invoices_with_payments(ids, !params[:convert_to_credit].blank?)
    @invoices = Invoice.unarchived.page(params[:page])
    respond_to { |format| format.js }
  end
   def dispute_invoice
     invoice_id = params[:invoice_id]
     invoice = Invoice.find(invoice_id)
     invoice.update_attribute('status','disputed')
     reason_for_dispute = params[:reason_for_dispute]
     InvoiceMailer.dispute_invoice_email(current_user, invoice, reason_for_dispute).deliver
     respond_to { |format| format.js }
   end
  def paypal_payments
    # send a post request to paypal to verify payment data
    response = RestClient.post("https://www.sandbox.paypal.com/cgi-bin/webscr", params.merge({"cmd" => "_notify-validate"}), :content_type => "application/x-www-form-urlencoded")
    invoice = Invoice.find(params[:invoice])
    # if status is verified make an entry in payments and update the status on invoice
    if response == "VERIFIED"
      invoice.payments.create({
          :payment_method => "paypal",
          :payment_amount => params[:payment_gross],
          :payment_date => Date.today,
          :notes => params[:txn_id],
          :paid_full => 1
                             })
      invoice.update_attribute('status', 'paid')
    end
    render :nothing => true
  end

end
