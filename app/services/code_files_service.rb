class CodeFilesService
  def self.for_demo(demo_type)
    case demo_type
    when "simple_purchase"
      [
        {
          name: "Workflow",
          filename: "simple_purchase_workflow.rb",
          path: "app/temporal/workflows/simple_purchase_workflow.rb",
          content: read_file_safely("app/temporal/workflows/simple_purchase_workflow.rb")
        },
        {
          name: "Process Payment",
          filename: "process_payment_activity.rb",
          path: "app/temporal/activities/process_payment_activity.rb",
          content: read_file_safely("app/temporal/activities/process_payment_activity.rb")
        },
        {
          name: "Send Confirmation",
          filename: "send_confirmation_email_activity.rb",
          path: "app/temporal/activities/send_confirmation_email_activity.rb",
          content: read_file_safely("app/temporal/activities/send_confirmation_email_activity.rb")
        }
      ]
    when "order_cancellation"
      [
        {
          name: "Workflow",
          filename: "order_cancellation_workflow.rb",
          path: "app/temporal/workflows/order_cancellation_workflow.rb",
          content: read_file_safely("app/temporal/workflows/order_cancellation_workflow.rb")
        },
        {
          name: "Payment Activity",
          filename: "payment_activity.rb",
          path: "app/temporal/activities/payment_activity.rb",
          content: read_file_safely("app/temporal/activities/payment_activity.rb")
        },
        {
          name: "Reserve Inventory",
          filename: "reserve_inventory_activity.rb",
          path: "app/temporal/activities/reserve_inventory_activity.rb",
          content: read_file_safely("app/temporal/activities/reserve_inventory_activity.rb")
        },
        {
          name: "Send Confirmation",
          filename: "send_confirmation_email_activity.rb",
          path: "app/temporal/activities/send_confirmation_email_activity.rb",
          content: read_file_safely("app/temporal/activities/send_confirmation_email_activity.rb")
        },
        {
          name: "Process Refund",
          filename: "process_refund_activity.rb",
          path: "app/temporal/activities/process_refund_activity.rb",
          content: read_file_safely("app/temporal/activities/process_refund_activity.rb")
        },
        {
          name: "Restock Inventory",
          filename: "restock_inventory_activity.rb",
          path: "app/temporal/activities/restock_inventory_activity.rb",
          content: read_file_safely("app/temporal/activities/restock_inventory_activity.rb")
        },
        {
          name: "Send Cancellation",
          filename: "send_cancellation_email_activity.rb",
          path: "app/temporal/activities/send_cancellation_email_activity.rb",
          content: read_file_safely("app/temporal/activities/send_cancellation_email_activity.rb")
        },
        {
          name: "Ship Order",
          filename: "ship_order_activity.rb",
          path: "app/temporal/activities/ship_order_activity.rb",
          content: read_file_safely("app/temporal/activities/ship_order_activity.rb")
        }
      ]
    else
      []
    end
  end

  private

  def self.read_file_safely(file_path)
    full_path = Rails.root.join(file_path)
    if File.exist?(full_path)
      File.read(full_path)
    else
      "# File not found: #{file_path}"
    end
  end
end
