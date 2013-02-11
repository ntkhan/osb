module Reporting
  class Criteria

    attr_accessor :from_date, :to_date, :client_id, :payment_method, :item_id

    def initialize(options={})
      Rails.logger.debug "--> Criteria init... #{options.to_yaml}"
      options ||= {} # if explicitly nil is passed then convert it to empty hash
      @from_date = (options[:from_date] || 1.month.ago).to_date
      @to_date = (options[:to_date] || Date.today).to_date
      @client_id = options[:client_id] || 0
      @payment_method = options[:payment_method] || 0
      @item_id = options[:item_id] || 0
      Rails.logger.debug "--> Criteria init... #{self.to_yaml}"
    end
  end
end
