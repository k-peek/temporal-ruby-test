require "temporalio/activity"
class ShipOrderActivity < Temporalio::Activity::Definition
  def execute(order_params, payment_result = nil, inventory_result = nil)
    customer_email = order_params["customer_email"]
    product = order_params["product"]
    payment_id = payment_result&.dig("payment_id") if payment_result

    puts "📮 Shipping order to #{customer_email}"
    puts "Product: #{product}"
    puts "Payment ID: #{payment_id}" if payment_id
    sleep(2)

    {
      tracking_number: "TRK#{SecureRandom.hex(6).upcase}",
      shipped_at: Time.current.iso8601,
      estimated_delivery: (Time.current + 3.days).iso8601,
      carrier: "FedEx"
    }
  end
end
