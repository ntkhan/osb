class ReportsController < ApplicationController
  include Reporting

  def index

  end

  def reports

    @report_name = params[:report_name]

    #prepare the criteria and report object
    @criteria = Reporting::Criteria.new(params)
    @report = Reporting::Report.new({:report_name => @report_name, :report_criteria => @criteria})
    #payments_collected

    respond_to do |format|
      format.html # index.html.erb
      #format.json { render :text => "json response" }
      format.js
      #format.json { render :json => @report }
    end
  end

  def reports_data
    @report_name = params[:report_name]

    #prepare the criteria and report object
    @criteria = Reporting::Criteria.new(params)
    @report = Reporting::Report.new({:report_name => @report_name, :report_criteria => @criteria})
    #payments_collected

    respond_to do |format|
      format.js
    end
  end
end