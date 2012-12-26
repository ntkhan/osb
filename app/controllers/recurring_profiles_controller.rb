class RecurringProfilesController < ApplicationController
  # GET /recurring_profiles
  # GET /recurring_profiles.json
  def index
    @recurring_profiles = RecurringProfile.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @recurring_profiles }
    end
  end

  # GET /recurring_profiles/1
  # GET /recurring_profiles/1.json
  def show
    @recurring_profile = RecurringProfile.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @recurring_profile }
    end
  end

  # GET /recurring_profiles/new
  # GET /recurring_profiles/new.json
  def new
    @recurring_profile = RecurringProfile.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @recurring_profile }
    end
  end

  # GET /recurring_profiles/1/edit
  def edit
    @recurring_profile = RecurringProfile.find(params[:id])
  end

  # POST /recurring_profiles
  # POST /recurring_profiles.json
  def create
    @recurring_profile = RecurringProfile.new(params[:recurring_profile])

    respond_to do |format|
      if @recurring_profile.save
        format.html { redirect_to @recurring_profile, notice: 'Recurring profile was successfully created.' }
        format.json { render json: @recurring_profile, status: :created, location: @recurring_profile }
      else
        format.html { render action: "new" }
        format.json { render json: @recurring_profile.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /recurring_profiles/1
  # PUT /recurring_profiles/1.json
  def update
    @recurring_profile = RecurringProfile.find(params[:id])

    respond_to do |format|
      if @recurring_profile.update_attributes(params[:recurring_profile])
        format.html { redirect_to @recurring_profile, notice: 'Recurring profile was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @recurring_profile.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /recurring_profiles/1
  # DELETE /recurring_profiles/1.json
  def destroy
    @recurring_profile = RecurringProfile.find(params[:id])
    @recurring_profile.destroy

    respond_to do |format|
      format.html { redirect_to recurring_profiles_url }
      format.json { head :no_content }
    end
  end
end
