class InvoicesController < ApplicationController
  before_filter :authenticate_user!, :except => [:preview]
  # GET /invoices
  # GET /invoices.json
  layout :choose_layout

  def index
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
    @invoice = Invoice.find(params[:id])
    render :layout=> "pdf_mode"
  end

  def preview
    @id = decrypt(Base64.decode64(params[:inv_id])).to_i rescue @id = nil
    @invoice = @id.blank? ? nil : Invoice.find(@id)
  end

  # GET /invoices/new
  # GET /invoices/new.json
  def new
    @invoice = Invoice.new({:invoice_number => Invoice.get_next_invoice_number(nil), :invoice_date => Date.today})
    3.times { @invoice.invoice_line_items.build() }

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @invoice }
    end
  end

  # GET /invoices/1/edit
  def edit
    @invoice = Invoice.find(params[:id])
  end

  # POST /invoices
  # POST /invoices.json
  def create
    @invoice = Invoice.new(params[:invoice])
    params[:save_as_draft] ? @invoice.status = "draft" : @invoice.status = "sent"
    respond_to do |format|
      if @invoice.save
        encrypted_id = Base64.encode64(encrypt(@invoice.id))
        InvoiceMailer.delay({:run_at => 1.minutes.from_now}).new_invoice_email(@invoice.client, @invoice, encrypted_id, current_user)
        # format.html { redirect_to @invoice, :notice => 'Your Invoice has been created successfully.' }
        format.json { render :json => @invoice, :status => :created, :location => @invoice }
        redirect_to({:action => "edit", :controller => "invoices", :id => @invoice.id}, :notice => 'Your Invoice has been created successfully.')
        return
      else
        format.html { render :action => "new" }
        format.json { render :json => @invoice.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /invoices/1
  # PUT /invoices/1.json
  def update
    @invoice = Invoice.find(params[:id])

    respond_to do |format|
      if @invoice.update_attributes(params[:invoice])
        #format.html { redirect_to @invoice, :notice => 'Invoice was successfully updated.' }
        format.json { head :no_content }
        redirect_to({:action => "edit", :controller => "invoices", :id => @invoice.id},:notice => 'Your Invoice has been updated successfully.')
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
    respond_to do |format|
      format.js
      format.html
    end
  end

  def bulk_actions
    ids = params[:invoice_ids]
    if params[:archive]
      Invoice.archive_multiple(ids)
      @invoices = Invoice.unarchived.page(params[:page])
      @action = "archived"
    elsif params[:destroy]
      Invoice.delete_multiple(ids)
      @invoices = Invoice.unarchived.page(params[:page])
      @action = "deleted"
    elsif params[:recover_archived]
      Invoice.recover_archived(ids)
      @invoices = Invoice.archived.page(params[:page])
      @action = "recovered from archived"
    elsif params[:recover_deleted]
      Invoice.recover_deleted(ids)
      @invoices = Invoice.only_deleted.page(params[:page])
      @action = "recovered from deleted"
    elsif params[:payment]
      unless Invoice.paid_invoices(ids).present?
        Invoice.paid_full(ids)
        @action = "paid"
      else
        @action = "paid invoices"
      end
      @invoices = Invoice.unarchived.page(params[:page])
    end
    respond_to { |format| format.js }
  end

  def filter_invoices
    @invoices = Invoice.filter(params)
  end

  def duplicate_invoice
    new_invoice = Invoice.find(params[:id]).duplicate_invoice
  end

  private
  def choose_layout
    action_name == 'preview' ? "preview_mode" : "application"
  end
end
