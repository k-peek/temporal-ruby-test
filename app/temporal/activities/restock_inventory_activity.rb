require "temporalio/activity"

class RestockInventoryActivity < Temporalio::Activity::Definition
  def execute(inventory_result)
    reservation_id = inventory_result["reservation_id"] || inventory_result[:reservation_id]
    product = inventory_result["product"] || inventory_result[:product] || "Premium Product"

    puts "📦 Restocking inventory for reservation: #{reservation_id}"
    sleep(rand(1..2))

    if rand < 0.98 # 98% success rate
      puts "✅ Inventory restocked successfully for #{product}"

      {
        "status" => "success",
        "product" => product,
        "reservation_id" => reservation_id,
        "restocked_at" => Time.current.iso8601,
        "message" => "#{product} inventory has been restocked and is available for sale again"
      }
    else
      # Simulate inventory system failure
      error_msg = "Inventory system temporarily unavailable - manual intervention required"
      puts "❌ Inventory restock failed: #{error_msg}"

      raise Temporalio::Error::ApplicationError.new(
        error_msg,
        type: "InventoryError",
        non_retryable: false
      )
    end
  end
end
