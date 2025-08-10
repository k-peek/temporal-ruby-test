require "temporalio/activity"
class SendConfirmationEmailActivity < Temporalio::Activity::Definition
  def execute(order_params, payment_result = nil, inventory_result = nil)
    customer_email = order_params["customer_email"]
    product = order_params["product"]
    payment_id = payment_result&.dig("payment_id") if payment_result

    puts "📧 Sending confirmation email to #{customer_email}"
    puts "Order: #{product}"
    puts "Payment ID: #{payment_id}" if payment_id

    # Simulate email sending
    sleep(1)

    {
      email_sent: true,
      sent_at: Time.current.iso8601,
      recipient: customer_email
    }
  end
end
