require "temporalio/activity"
class PrePurchaseInventoryActivity < Temporalio::Activity::Definition
  def execute(order_params)
    product = order_params["product"]

    puts "🏪 Checking pre-purchase inventory for #{product}"
    sleep(2) # Simulate inventory system call

    # Simulate inventory check - 90% chance of having stock for pre-purchase
    has_stock = rand < 0.9

    {
      product: product,
      available: has_stock,
      checked_at: Time.current.iso8601,
      stock_level: has_stock ? rand(1..10) : 0
    }
  end
end
