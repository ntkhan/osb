class ClientBillingInfosController < ApplicationController
  before_filter :authenticate_user!
  # GET /client_billing_infos
  # GET /client_billing_infos.json
  def index
    @client_billing_infos = ClientBillingInfo.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @client_billing_infos }
    end
  end

  # GET /client_billing_infos/1
  # GET /client_billing_infos/1.json
  def show
    @client_billing_info = ClientBillingInfo.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @client_billing_info }
    end
  end

  # GET /client_billing_infos/new
  # GET /client_billing_infos/new.json
  def new
    @client_billing_info = ClientBillingInfo.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @client_billing_info }
    end
  end

  # GET /client_billing_infos/1/edit
  def edit
    @client_billing_info = ClientBillingInfo.find(params[:id])
  end

  # POST /client_billing_infos
  # POST /client_billing_infos.json
  def create
    @client_billing_info = ClientBillingInfo.new(params[:client_billing_info])

    respond_to do |format|
      if @client_billing_info.save
        format.html { redirect_to @client_billing_info, notice: 'Client billing info was successfully created.' }
        format.json { render json: @client_billing_info, status: :created, location: @client_billing_info }
      else
        format.html { render action: "new" }
        format.json { render json: @client_billing_info.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /client_billing_infos/1
  # PUT /client_billing_infos/1.json
  def update
    @client_billing_info = ClientBillingInfo.find(params[:id])

    respond_to do |format|
      if @client_billing_info.update_attributes(params[:client_billing_info])
        format.html { redirect_to @client_billing_info, notice: 'Client billing info was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @client_billing_info.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /client_billing_infos/1
  # DELETE /client_billing_infos/1.json
  def destroy
    @client_billing_info = ClientBillingInfo.find(params[:id])
    @client_billing_info.destroy

    respond_to do |format|
      format.html { redirect_to client_billing_infos_url }
      format.json { head :no_content }
    end
  end
end
