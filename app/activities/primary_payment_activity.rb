require "temporalio/activity"
class PrimaryPaymentActivity < Temporalio::Activity::Definition
  def execute(order_params)
    customer_email = order_params["customer_email"]
    product = order_params["product"]
    amount = order_params["amount"]

    puts "💳 Processing primary payment (Credit Card) for #{customer_email} - #{product} ($#{amount})"
    sleep(2)

    # 60% success rate
    success = rand < 0.6

    if success
      {
        payment_id: "cc_#{SecureRandom.hex(8)}",
        method: "credit_card",
        status: "completed",
        amount: amount,
        processed_at: Time.current.iso8601
      }
    else
      raise "Primary payment failed: Card declined"
    end
  end
end
