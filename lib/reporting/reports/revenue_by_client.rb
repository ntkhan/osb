module Reporting
  module Reports
    class RevenueByClient < Reporting::Report
      def initialize(options={})
        #raise "debugging..."
        @report_name = options[:report_name] || "no report"
        @report_criteria = options[:report_criteria]
        @report_data = get_report_data
        @report_total = 0
        calculate_report_total
        #raise "debugging..."
      end

      def period
        @report_criteria.year
      end

      def get_report_data
        # Report columns Client name, January to December months (12 columns)
        # Prepare 12 (month) columns for payment total against each month
        month_wise_payment = []
        12.times { |month| month_wise_payment << "SUM(CASE WHEN MONTH(p.created_at) = #{month+1} THEN payment_amount ELSE NULL END) AS #{Date::MONTHNAMES[month+1]}" }
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

      def calculate_report_total
        @report_total = @report_data.inject(0){|total, payment| total + (payment.attributes["client_total"] || 0)}
      end
    end
  end
end