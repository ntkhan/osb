class ReportsController < ApplicationController
  include Reporting

  def index

  end


  # first time report load
  # reports/:report_name
  def reports
    Rails.logger.debug "--> in reports_controller#report... #{params.inspect} "
    @report = get_report(params)

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # AJAX request to fetch report data after
  # reports/data/:report_name
  def reports_data

    @report = get_report(params)

    respond_to do |format|
      format.js
    end
  end

  private

  def get_report(options={})
    @criteria = Reporting::Criteria.new(options[:criteria]) # report criteria
    Reporting::Reporter.get_report({:report_name => options[:report_name], :report_criteria => @criteria})
  end
end