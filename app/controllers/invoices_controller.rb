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
      format.json { render :json => @invoice }
    end
  end

  def preview
    id = decrypt(Base64.decode64(params[:inv_id])).to_i rescue id = nil
    @invoice = id.blank? ? nil : Invoice.find(id)
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
        InvoiceMailer.new_invoice_email(@invoice.client, @invoice, encrypted_id, current_user).deliver
        format.html { redirect_to @invoice, :notice => 'Invoice was successfully created.' }
        format.json { render :json => @invoice, :status => :created, :location => @invoice }
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
        format.html { redirect_to @invoice, :notice => 'Invoice was successfully updated.' }
        format.json { head :no_content }
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
    if params[:archive]
      Invoice.archive_multiple(params[:invoice_ids])
      @action = "archived"
    elsif params[:destroy]
      Invoice.delete_multiple(params[:invoice_ids])
      @action = "deleted"
    end
    @invoices = Invoice.unarchived.page(params[:page])
    respond_to { |format| format.js }
  end

  def filter_invoices
    @invoices = Invoice.filter(params)
  end

  private
  def choose_layout
    action_name == 'preview' ? "preview_mode" : "application"
  end
end
