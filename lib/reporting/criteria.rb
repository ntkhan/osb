module Reporting
  class Criteria

    attr_accessor :from_date, :to_date, :client_id, :payment_method, :item_id

    def initialize(options={})
      @from_date = options[:from_date] || 1.month.ago
      @to_date = options[:to_date] || Date.today
      @client_id = options[:client_id] || 0
      @payment_method = options[:payment_method] || 0
      @item_id = options[:item_id] || 0
    end
  end
end
