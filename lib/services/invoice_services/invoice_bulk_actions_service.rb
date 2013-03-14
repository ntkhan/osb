module Services
  module InvoiceServices
    class InvoiceBulkActionsService
      def initialize(options)
        @options ||= options
        @action_to_perform = @options[:commit]
      end

      def perform
        return method(@action_to_perform).call
      end

      def archive
        puts "in #{caller[0][/`([^']*)'/, 1]}"
      end

      def destroy
        puts "in #{caller[0][/`([^']*)'/, 1]}"
      end

      def recover_archived
        puts "in #{caller[0][/`([^']*)'/, 1]}"
      end

      def recover_deleted
        puts "in #{caller[0][/`([^']*)'/, 1]}"
      end

      def send_invoice
        puts "in #{caller[0][/`([^']*)'/, 1]}"
      end

      def enter_payment
        puts "in #{caller[0][/`([^']*)'/, 1]}"
      end

    end
  end
end