require "temporalio/activity"
class PaymentFailureEmailActivity < Temporalio::Activity::Definition
  def execute(order_params, failed_attempts)
    customer_email = order_params["customer_email"]
    product = order_params["product"]

    puts "📧 Sending payment failure email to #{customer_email}"
    puts "Failed payment methods: #{failed_attempts.join(', ')}"
    sleep(1)

    {
      email_sent: true,
      sent_at: Time.current.iso8601,
      recipient: customer_email,
      failed_methods: failed_attempts
    }
  end
end
