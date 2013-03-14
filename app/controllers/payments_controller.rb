class PaymentsController < ApplicationController
  before_filter :authenticate_user!, :except => [:payments_history]
  # GET /payments
  # GET /payments.json
  layout :choose_layout
  include PaymentsHelper

  def index
    @payments = Payment.unarchived.page(params[:page]).per(params[:per])

    respond_to do |format|
      format.html # index.html.erb
      format.js
    end
  end

  # GET /payments/1
  # GET /payments/1.json
  def show
    @payment = Payment.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @payment }
    end
  end

  # GET /payments/new
  # GET /payments/new.json
  def new
    @payment = Payment.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @payment }
    end
  end

  # GET /payments/1/edit
  def edit
    @payment = Payment.find(params[:id])
  end

  # POST /payments
  # POST /payments.json
  def create
    @payment = Payment.new(params[:payment])

    respond_to do |format|
      if @payment.save
        format.html { redirect_to @payment, :notice => 'The payment has been recorded successfully.' }
        format.json { render :json => @payment, :status => :created, :location => @payment }
      else
        format.html { render :action => "new" }
        format.json { render :json => @payment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /payments/1
  # PUT /payments/1.json
  def update
    @payment = Payment.find(params[:id])
    latest_amount = Payment.update_invoice_status params[:payment][:invoice_id], params[:payment][:payment_amount].to_i, @payment.payment_amount.to_i
    params[:payment][:payment_amount] = latest_amount
    respond_to do |format|
      if @payment.update_attributes(params[:payment])
        format.html { redirect_to(edit_payment_url(@payment), :notice => 'Your Payment has been updated successfully.') }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @payment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /payments/1
  # DELETE /payments/1.json
  def destroy
    @payment = Payment.find(params[:id])
    @payment.destroy

    respond_to do |format|
      format.html { redirect_to payments_url }
      format.json { head :no_content }
    end
  end

  def enter_payment
    ids = params[:invoice_ids]
    @payments = []
    ids = ids.split(",") if ids and ids.is_a?(String)
    unless params[:pay_invoice]
      ids.each do |inv_id|
        payment = Payment.new({:invoice_id => inv_id, :payment_date => Date.today})
        @payments << payment
      end
    else
      @payments << Payment.new({:invoice_id => params[:invoice_id], :payment_date => Date.today})
      respond_to { |format| format.js }
    end
  end

  def update_individual_payment
    params[:payments].delete_if { |payment| payment["payment_amount"].blank? }.each do |pay|
      pay[:payment_amount] = Payment.update_invoice_status pay[:invoice_id], pay[:payment_amount].to_f
      pay[:payment_date] ||= Date.today
      Payment.create!(pay).notify_client current_user.email
    end
    unless params[:pay_invoice]
      redirect_to(payments_url, :notice => 'Payments against selected invoices have been recorded successfully.')
    else
      @invoices = Invoice.unarchived.page(params[:page])
      respond_to { |format| format.js }
    end
  end

  def bulk_actions
    ids = params[:payment_ids]
    if params[:archive]
      Payment.archive_multiple(ids)
      @payments = Payment.unarchived.page(params[:page]).per(params[:per])
      @action = "archived"
      @message = payments_archived(ids) unless ids.blank?
    elsif params[:destroy]
      # check if payment is a credit and applied to any other invoice payment
      if Payment.is_credit_entry? ids
        @action = "credit entry"
        @payments_with_credit = Payment.payments_with_credit ids
      else
        Payment.delete_multiple(ids)
        @payments = Payment.unarchived.page(params[:page]).per(params[:per])
        @action = "deleted"
        @message = payments_deleted(ids) unless ids.blank?
      end
    elsif params[:recover_archived]
      Payment.recover_archived(ids)
      @payments = Payment.archived.page(params[:page]).per(params[:per])
      @action = "recovered from archived"
    elsif params[:recover_deleted]
      Payment.recover_deleted(ids)
      @payments = Payment.only_deleted.page(params[:page]).per(params[:per])
      @action = "recovered from deleted"
    end
    respond_to { |format| format.js }
  end

  def filter_payments
    @payments = Payment.filter(params)
  end

  def undo_actions
    params[:archived] ? Payment.recover_archived(params[:ids]) : Payment.recover_deleted(params[:ids])
    @payments = Payment.unarchived.page(params[:page]).per(params[:per])
    respond_to { |format| format.js }
  end

  def payments_history
    client = Invoice.find_by_id(params[:id]).client
    @payments = Payment.payments_history(client).page(params[:page])
  end

  def invoice_payments_history
    client = Invoice.find_by_id(params[:id]).client
    @payments = Payment.payments_history(client).page(params[:page])
    @invoice = Invoice.find(params[:id])
  end

end
