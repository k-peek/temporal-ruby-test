require "temporalio/activity"
class SecondaryPaymentActivity < Temporalio::Activity::Definition
  def execute(order_params)
    customer_email = order_params["customer_email"]
    product = order_params["product"]
    amount = order_params["amount"]

    puts "💳 Processing secondary payment (Backup Card) for #{customer_email} - #{product} ($#{amount})"
    sleep(2)

    # 80% success rate
    success = rand < 0.8

    if success
      {
        payment_id: "bc_#{SecureRandom.hex(8)}",
        method: "backup_card",
        status: "completed",
        amount: amount,
        processed_at: Time.current.iso8601
      }
    else
      raise "Secondary payment failed: Backup card also declined"
    end
  end
end
