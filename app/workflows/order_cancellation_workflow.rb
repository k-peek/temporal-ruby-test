require "temporalio/workflow"

class OrderCancellationWorkflow < Temporalio::Workflow::Definition
  def execute(order_params)
    payment_result = Temporalio::Workflow.execute_activity(
      PaymentActivity,
      order_params,
      schedule_to_close_timeout: 30
    )

    inventory_result = Temporalio::Workflow.execute_activity(
      ReserveInventoryActivity,
      order_params,
      schedule_to_close_timeout: 30
    )

    Temporalio::Workflow.execute_activity(
      SendConfirmationEmailActivity,
      order_params,
      payment_result,
      inventory_result,
      schedule_to_close_timeout: 30
    )

    Temporalio::Workflow.wait_condition do
     @customer_cancel_order || @supplier_cancel_order || @order_ready_to_ship
    end

    if @customer_cancel_order || @supplier_cancel_order
      refund_result = Temporalio::Workflow.execute_activity(
        ProcessRefundActivity,
        payment_result,
        schedule_to_close_timeout: 30
      )

      Temporalio::Workflow.execute_activity(
        RestockInventoryActivity,
        inventory_result,
        schedule_to_close_timeout: 30
      )

      Temporalio::Workflow.execute_activity(
        SendCancellationEmailActivity,
        order_params,
        refund_result,
        inventory_result,
        schedule_to_close_timeout: 30
      )
    elsif @order_ready_to_ship
      Temporalio::Workflow.execute_activity(
        ShipOrderActivity,
        order_params,
        payment_result,
        inventory_result,
        schedule_to_close_timeout: 30
      )
    else
      Temporalio::Workflow.logger.info "Timed out waiting for a decision."
    end
  end

  workflow_signal
  def customer_cancel_order
    @customer_cancel_order = true
  end

  workflow_signal
  def supplier_cancel_order
    @supplier_cancel_order = true
  end

  workflow_signal
  def order_ready_to_ship
    @order_ready_to_ship = true
  end
end
