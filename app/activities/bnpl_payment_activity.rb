require "temporalio/activity"
class BnplPaymentActivity < Temporalio::Activity::Definition
  def execute(order_params)
    customer_email = order_params["customer_email"]
    product = order_params["product"]
    amount = order_params["amount"]

    puts "💰 Processing Buy Now Pay Later for #{customer_email} - #{product} ($#{amount})"
    sleep(2)

    # 95% success rate
    success = rand < 0.95

    if success
      {
        payment_id: "bnpl_#{SecureRandom.hex(8)}",
        method: "buy_now_pay_later",
        status: "approved",
        amount: amount,
        processed_at: Time.current.iso8601,
        payment_schedule: "4 installments of $#{(amount.to_f / 4).round(2)}"
      }
    else
      raise "BNPL payment failed: Credit check failed"
    end
  end
end
