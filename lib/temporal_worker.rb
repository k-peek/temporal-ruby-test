require "temporalio/worker"

class TemporalWorker
  def self.start
    client = TemporalClient.client
    task_queue = TemporalClient.task_queue

    puts "🚀 Starting Temporal worker..."
    puts "Task Queue: #{task_queue}"
    puts "Temporal Host: #{TemporalClient.host}"

    # Create worker with all our workflows and activities
    worker = Temporalio::Worker.new(
      client: client,
      task_queue: task_queue,
      workflows: [
        SimplePurchaseWorkflow,
        PaymentRetryWorkflow,
        OrderCancellationWorkflow
      ],
      activities: [
        # Basic activities
        ProcessPaymentActivity,
        PaymentActivity,
        SendConfirmationEmailActivity,

        # Payment retry activities
        PrimaryPaymentActivity,
        SecondaryPaymentActivity,
        BnplPaymentActivity,
        PaymentFailureEmailActivity,

        # Order cancellation activities
        ReserveInventoryActivity,
        ShipOrderActivity,
        ProcessRefundActivity,
        RestockInventoryActivity,
        SendCancellationEmailActivity,

        # Inventory activities
        PrePurchaseInventoryActivity,
        CheckInventoryActivity
      ]
    )

    puts "✅ Worker configured with workflows and activities"

    # Start the worker
    puts "🏃 Worker starting..."
    worker.run
  rescue => e
    puts "❌ Worker failed to start: #{e.message}"
    puts e.backtrace.join("\n")
    raise
  end
end
