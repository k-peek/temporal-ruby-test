require "temporalio/activity"

class ProcessRefundActivity < Temporalio::Activity::Definition
  def execute(payment_result)
    payment_id = payment_result["payment_id"] || payment_result[:payment_id]
    amount = payment_result["amount"] || payment_result[:amount]

    puts "💸 Processing refund for payment: #{payment_id}"
    sleep(rand(1..3))

    refund_id = "refund_#{SecureRandom.hex(8)}"

    if rand < 0.95 # 95% success rate
      puts "✅ Refund processed successfully: #{refund_id}"

      {
        "status" => "success",
        "refund_id" => refund_id,
        "amount" => amount,
        "original_payment_id" => payment_id,
        "processed_at" => Time.current.iso8601,
        "message" => "Refund of $#{amount} processed to original payment method"
      }
    else
      # Simulate refund failure
      error_msg = "Unable to process refund - payment method no longer valid"
      puts "❌ Refund failed: #{error_msg}"

      raise Temporalio::Error::ApplicationError.new(
        error_msg,
        type: "RefundError",
        non_retryable: false
      )
    end
  end
end
