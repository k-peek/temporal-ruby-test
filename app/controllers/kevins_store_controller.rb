class KevinsStoreController < ApplicationController
  def index
    @demos = DemoDefinitionsService.all

    respond_to do |format|
      format.html # Will render app/views/kevins_store/index.html.erb
      format.json do
        render json: {
          store: "Kevin's Store",
          subtitle: "Temporal Workflow Demos",
          demos: @demos,
          temporal_config: {
            host: TemporalClient.host,
            namespace: TemporalClient.namespace,
            task_queue: TemporalClient.task_queue
          }
        }
      end
    end
  end

  def simple_purchase
    order_params = extract_order_params
    workflow_result = ::WorkflowService.start_workflow(SimplePurchaseWorkflow, order_params)

    # Store result data in session for the redirect
    session[:workflow_result] = {
      demo: "Simple Purchase",
      description: "Basic purchase with payment and confirmation email",
      workflow_id: workflow_result[:workflow_id],
      order_params: order_params,
      status: workflow_result[:status]
    }

    respond_to do |format|
      format.html { redirect_to "/kevins_store/result/#{workflow_result[:workflow_id]}" }
      format.json { render json: session[:workflow_result] }
    end
  end

  def order_cancellation
    order_params = extract_order_params

    # Add cancellation window (default to 1 minute for demo)
    cancellation_minutes = params[:cancellation_minutes]&.to_i || 1
    order_params["cancellation_window_seconds"] = cancellation_minutes * 60

    workflow_result = ::WorkflowService.start_workflow(OrderCancellationWorkflow, order_params)

    # Store result data in session for the redirect
    session[:workflow_result] = {
      demo: "Order Cancellation with Compensation",
      description: "Complete purchase with #{cancellation_minutes} minute cancellation window. Shows compensating actions if cancelled.",
      workflow_id: workflow_result[:workflow_id],
      order_params: order_params,
      cancellation_minutes: cancellation_minutes,
      status: workflow_result[:status]
    }

    respond_to do |format|
      format.html { redirect_to "/kevins_store/result/#{workflow_result[:workflow_id]}" }
      format.json { render json: session[:workflow_result] }
    end
  end

  def result
    workflow_id = params[:workflow_id]

    # Get stored result from session or create a basic one
    @result = session[:workflow_result] || {
      "demo" => "Workflow Result",
      "description" => "Workflow execution result",
      "workflow_id" => workflow_id,
      "order_params" => { "customer_email" => "Unknown", "product" => "Unknown", "amount" => "0.00" },
      "status" => "started"
    }

    # Check current status from Temporal
    current_status = ::WorkflowService.get_status(workflow_id)
    @result["status"] = current_status[:status]
    @result["workflow_id"] = workflow_id

    if current_status[:completed_at]
      @result["completed_at"] = current_status[:completed_at]
    end

    if current_status[:error]
      @result["error"] = current_status[:error]
    else
      # Clear any old errors from session
      @result.delete("error")
    end

    render :result
  end


  private

  def extract_order_params
    {
      "customer_email" => params[:customer_email] || "customer@example.com",
      "product" => params[:product] || "Premium Product",
      "amount" => params[:amount] || 399.99
    }
  end
end
