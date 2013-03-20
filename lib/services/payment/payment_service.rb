module Services
  #payment related business logic will go here
  class PaymentService

    # how much credit is applied from which credit payment
    def self.distribute_credit_payment(payment,client_email)
      payment_amount = payment[:payment_amount]
      invoice = Invoice.find(payment[:invoice_id])
      client = invoice.client
      remaining, collected = payment_amount, 0

      new_credit_payment = Payment.create!(payment)
      new_credit_payment.notify_client(client_email)

      # loop through all the credit payments of client
        client.credit_payments.each do |credit_payment|

          credit_amount, credit_applied = credit_payment.payment_amount.to_f, credit_payment.credit_applied.to_f
          credit_amount -= credit_applied
          current = remaining >= credit_amount ? {:amount => credit_amount, :still_remaining => true} : {:amount => remaining, :still_remaining => false}
          collected += current[:still_remaining] ? current[:amount] : remaining
          credit_applied += current[:amount]
          remaining = payment_amount - collected

          credit_payment.update_attribute('credit_applied', credit_applied)
          CreditPayment.create({:payment_id => credit_payment.id, :invoice_id => credit_payment.invoice_id, :amount => credit_applied, :credit_id => new_credit_payment.id})

          break if remaining == 0
        end unless client.credit_payments.blank?

    end
  end
end