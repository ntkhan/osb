module Reporting

  class Report
    #include ClassLevelInheritableAttributes
    attr_accessor :report_name, :report_criteria, :report_data, :client_name, :report_duration, :report_total
  end

  class RevenueByClient < Reporting::Report
    def initialize(options={})
      #raise "debugging..."
      @report_name = options[:report_name] || "no report"
      @report_criteria = options[:report_criteria]
      @report_data = get_report_data
      #raise "debugging..."
    end

    def period
      @report_criteria.year
    end


    def get_report_data
      # Report columns Client name, January to December months (12 columns)
      # Prepare 12 (month) columns for payment total against each month
      month_wise_payment = []
      12.times{|month| month_wise_payment << "SUM(CASE WHEN MONTH(p.created_at) = #{month+1} THEN payment_amount ELSE NULL END) AS #{Date::MONTHNAMES[month+1]}"}
      month_wise_payment = month_wise_payment.join(", \n")
      client_filter = @report_criteria.client_id == 0 ? "" : " AND i.client_id = #{@report_criteria.client_id}"
      revenue_by_client = Payment.find_by_sql("
                SELECT c.organization_name, #{month_wise_payment}, SUM(p.payment_amount) AS client_total
                FROM payments p INNER JOIN invoices i ON p.invoice_id = i.id INNER JOIN clients c ON i.client_id = c.id
                WHERE year(p.created_at) = #{@report_criteria.year}
                #{client_filter}
					      GROUP BY c.organization_name, month(p.created_at)
              ")
      revenue_by_client
    end
  end

  class PaymentsCollected < Reporting::Report
    def initialize(options={})
      #raise "debugging..."
      @report_name = options[:report_name] || "no report"
      @report_criteria = options[:report_criteria]
      @report_data = get_report_data
      @report_total= @report_data.inject(0) { |total, p| total + p[:payment_amount] }
    end

    def period
      "Between #{@report_criteria.from_date} and #{@report_criteria.to_date}"
    end

    def client_name
      @report_criteria.client_id == 0 ? "All Clients" : Client.where(:id => @report_criteria.client_id).first.organization_name
    end

    def get_report_data
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
        payments.created_at").includes(:invoice => :client).joins(:invoice => :client).where("payments.created_at" => @report_criteria.from_date.to_time.begging_of_day..@report_criteria.to_date.to_time.end_of_day)

      payments = payments.where(["clients.id = ?", @report_criteria.client_id]) unless @report_criteria.client_id == 0
      payments = payments.where(["payments.payment_method = ?", @report_criteria.payment_method]) unless @report_criteria.payment_method == ""
      payments = payments.except(:order)
      payments
    end
  end
end