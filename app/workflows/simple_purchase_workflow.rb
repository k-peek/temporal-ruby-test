require "temporalio/workflow"

class SimplePurchaseWorkflow < Temporalio::Workflow::Definition
  def execute(order_params)
    # Step 1: Process payment
    payment_result = Temporalio::Workflow.execute_activity(ProcessPaymentActivity, order_params)

    # Step 2: Send confirmation email
    email_result = Temporalio::Workflow.execute_activity(SendConfirmationEmailActivity, order_params, payment_result)

    # Return final result
    {
      workflow_type: "simple_purchase",
      order_status: "completed",
      payment: payment_result,
      email: email_result,
      completed_at: Temporalio::Workflow.now.iso8601
    }
  end
end
