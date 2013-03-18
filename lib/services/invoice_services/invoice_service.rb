#
# Open Source Billing - A super simple software to create & send invoices to your customers and
# collect payments.
# Copyright (C) 2013 Mark Mian <mark.mian@opensourcebilling.org>
#
# This file is part of Open Source Billing.
#
# Open Source Billing is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Open Source Billing is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Open Source Billing.  If not, see <http://www.gnu.org/licenses/>.
#
module Services
  module InvoiceServices
# invoice related business logic will go here
    class InvoiceService

      # build a new invoice object
      def self.build_new_invoice(params)
        if params[:invoice_for_client]
          invoice = Invoice.new({:invoice_number => Invoice.get_next_invoice_number(nil), :invoice_date => Date.today, :client_id => params[:invoice_for_client]})
          3.times { invoice.invoice_line_items.build() }
        elsif params[:id]
          invoice = Invoice.find(params[:id]).use_as_template
          invoice.invoice_line_items.build()
        else
          invoice = Invoice.new({:invoice_number => Invoice.get_next_invoice_number(nil), :invoice_date => Date.today})
          3.times { invoice.invoice_line_items.build() }
        end
        invoice
      end

      # invoice bulk actions
      def perform_bulk_action(params)
        return InvoiceBulkActionService.perfom(params)
      end

    end
  end
end