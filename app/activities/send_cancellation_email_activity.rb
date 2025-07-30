require "temporalio/activity"
class SendCancellationEmailActivity < Temporalio::Activity::Definition
  def execute(order_params, refund_result = nil, inventory_result = nil)
    customer_email = order_params["customer_email"]
    product = order_params["product"]
    refund_id = refund_result&.dig("refund_id") if refund_result

    puts "📧 Sending cancellation email to #{customer_email}"
    puts "Product: #{product}"
    puts "Refund ID: #{refund_id}" if refund_id

    # Simulate email sending
    sleep(1)

    {
      cancellation_email_sent: true,
      sent_at: Time.current.iso8601,
      recipient: customer_email,
      refund_id: refund_id
    }
  end
end
