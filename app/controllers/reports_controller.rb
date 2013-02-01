class ReportsController < ApplicationController
  include Reporting

  def index

  end

  def payments_collected
    criteria = params
    @payments_collected = Reports.payments_collected(criteria)
  end
end