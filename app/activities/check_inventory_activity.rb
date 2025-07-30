require "temporalio/activity"
class CheckInventoryActivity < Temporalio::Activity::Definition
  def execute(order_params)
    product = order_params["product"]

    puts "Checking inventory for #{product}"
    sleep(3) # Simulate warehouse API call

    # Simulate inventory check - 70% chance of having stock
    has_stock = rand < 0.7

    {
      product: product,
      in_stock: has_stock,
      checked_at: Time.current.iso8601,
      warehouse_response: has_stock ? "Item available" : "Out of stock"
    }
  end
end
