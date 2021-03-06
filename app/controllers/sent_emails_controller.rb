class SentEmailsController < ApplicationController
  def index
    @sent_emails = SentEmail.page(params[:page]).per(params[:per]).order('created_at DESC')
  end

  def show
    @sent_email = SentEmail.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
    end
  end
end
