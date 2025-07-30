require "temporalio/activity"
class ReserveInventoryActivity < Temporalio::Activity::Definition
  def execute(order_params)
    product = order_params["product"]
    customer_email = order_params["customer_email"]

    puts "📦 Reserving inventory for: #{product}"
    puts "Customer: #{customer_email}"
    sleep(2)

    # 95% success rate for inventory reservations
    success = rand < 0.95

    if success
      {
        reservation_id: "res_#{SecureRandom.hex(8)}",
        product: product,
        reserved_for: customer_email,
        reserved_at: Time.current.iso8601,
        expires_at: (Time.current + 24.hours).iso8601
      }
    else
      raise "Inventory reservation failed: Unable to reserve item"
    end
  end
end
