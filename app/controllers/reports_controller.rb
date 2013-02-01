class ReportsController < ApplicationController
  include Reporting

  def index

  end

  def payments_collected
    criteria = params
    @payments_collected = Reports.payments_collected(criteria)
    @payments_total = @payments_collected .reject{|payment| payment[:payment_method] == "check"}
                                          .inject(0){|total, payment| total + payment[:payment_amount]}
  end
end