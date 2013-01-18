class PaymentsController < ApplicationController
  # GET /payments
  # GET /payments.json
  def index
    @payments = Payment.page(params[:page])

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
      format.json { render json: @payment }
    end
  end

  # GET /payments/new
  # GET /payments/new.json
  def new
    @payment = Payment.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @payment }
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
        format.html { redirect_to @payment, notice: 'Payment was successfully created.' }
        format.json { render json: @payment, status: :created, location: @payment }
      else
        format.html { render action: "new" }
        format.json { render json: @payment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /payments/1
  # PUT /payments/1.json
  def update
    @payment = Payment.find(params[:id])

    respond_to do |format|
      if @payment.update_attributes(params[:payment])
        format.html { redirect_to @payment, notice: 'Payment was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @payment.errors, status: :unprocessable_entity }
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
    params[:invoice_ids].each do |inv_id|
      if Payment.where("invoice_id =#{inv_id} and payment_amount is null").last.blank?
        payment = Payment.new
        payment.invoice_id = inv_id
        payment.save
      end
    end
    @payments = Payment.where("payment_amount is null and invoice_id in (?)",params[:invoice_ids]).all
  end
  def update_individual_payment
    params[:payments].values.each do |pay|
       pay[:payment_amount] = Payment.update_invoice_status pay[:invoice_id], pay[:payment_amount].to_i
    end   
    @payments = Payment.update(params[:payments].keys, params[:payments].values)
    redirect_to payments_url
  end
end
