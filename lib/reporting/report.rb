module Reporting
  class Report
    attr_accessor :report_name, :report_criteria, :report_data
    # @param [options]
    def initialize(options={})
      @report_name = options[:report_name] || "no report"
      @report_criteria = options[:report_criteria]
      @report_data = get_report_data
    end

    def get_report_data
      case @report_name
        when "payments_collected"
          payments_collected
        else # for time being return same data for all reports
          payments_collected
      end
    end

    def payments_collected
      # Report columns: Invoice# 	Client Name 	Type 	Note 	Date 	Amount
      payments = Payment.select(
          "payments.id as payment_id,
        invoices.invoice_number,
        invoices.id as invoice_id,
        clients.organization_name as client_name,
        payments.payment_type,
        payments.payment_method,
        payments.notes,
        payments.payment_amount,
        payments.created_at").includes(:invoice => :client).joins(:invoice => :client).where(:created_at => @report_criteria.from_date..@report_criteria.to_date)

      payments.where(["clients.id = ?", @report_criteria.client_id]) unless @report_criteria.client_id == 0
      payments.where(["payments.payment_method = ?", @report_criteria[:payment_method]]) unless @report_criteria.payment_method == 0

      payments
    end
  end
end