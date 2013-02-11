module Reporting

  #  Responsible to build a report. From Controllers we'll invoke Reporter.get_report with params to get a report object
  module Reporter
    # Receives report name and criteria as an options hash  and returns the Report object
    def self.get_report options={}
      report_name = options[:report_name] || "no report"
      report =  "Reporting::#{report_name.camelize}".constantize.new(options)
    end
  end
end