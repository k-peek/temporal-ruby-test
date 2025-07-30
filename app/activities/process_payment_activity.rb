require "temporalio/activity"

class ProcessPaymentActivity < Temporalio::Activity::Definition
  def execute(order_params)
    customer_email = order_params["customer_email"]
    product = order_params["product"]
    amount = order_params["amount"]

    # Simulate payment processing
    puts "Processing payment for #{customer_email} - #{product} ($#{amount})"
    sleep(2) # Simulate network delay

    # Return payment result
    {
      payment_id: "pay_#{SecureRandom.hex(8)}",
      status: "completed",
      amount: amount,
      processed_at: Time.current.iso8601
    }
  end
end
