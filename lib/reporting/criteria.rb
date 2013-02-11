module Reporting
  class Criteria

    # criteria attributes for *Payments Collected* report
    attr_accessor :from_date, :to_date, :client_id, :payment_method

    # attributes for *Revenue by Clients* report
    attr_accessor :year

    def initialize(options={})
      Rails.logger.debug "--> Criteria init... #{options.to_yaml}"
      options ||= {} # if explicitly nil is passed then convert it to empty hash
      @from_date = (options[:from_date] || 1.month.ago).to_date # default for one month back from today
      @to_date = (options[:to_date] || Date.today).to_date # default to today
      @client_id = (options[:client_id] || 0).to_i # default to all i.e. 0
      @payment_method = (options[:payment_method] || "") # default to all i.e. ""

      @year = (options[:year] || Date.today.year).to_i # default to current year
      Rails.logger.debug "--> Criteria init... #{self.to_yaml}"
    end
  end
end
