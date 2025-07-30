class BobsGameStoreController < ApplicationController
  def index
    @demos = [
      {
        name: "Simple Purchase",
        description: "Basic payment → confirmation email workflow",
        path: "/bobs_game_store/simple_purchase",
        features: [ "Sequential activities", "Basic workflow patterns" ],
        mermaid: %(
          flowchart TD
            A((Start Purchase)) --> B[Process Payment]
            B --> C[Send Confirmation Email]
            C --> D((End))

            style A fill:#4fc3f7,stroke:#01579b,stroke-width:3px,color:#000
            style B fill:#ffb74d,stroke:#e65100,stroke-width:2px,color:#000
            style C fill:#ba68c8,stroke:#4a148c,stroke-width:2px,color:#000
            style D fill:#81c784,stroke:#2e7d32,stroke-width:3px,color:#000
        ),
        code_files: get_code_files_for_demo("simple_purchase")
      },
      {
        name: "Order Cancellation with Compensation",
        description: "Complete purchase → Customer cancels → Refund & restock inventory",
        path: "/bobs_game_store/order_cancellation",
        features: [ "Compensating actions", "Saga pattern", "Rollback operations" ],
        mermaid: %(
          flowchart TD
            A((Start Purchase)) --> B[Process Payment]
            B --> C[Reserve Inventory]
            C --> D[Send Confirmation Email]
            D --> E{Wait for Cancellation Window}
            E -->|No Cancellation| F[Ship Order]
            E -->|Customer Cancels| G[Process Refund]
            G --> H[Restock Inventory]
            H --> I[Send Cancellation Email]
            F --> J((Order Shipped))
            I --> K((Order Cancelled))

            style A fill:#4fc3f7,stroke:#01579b,stroke-width:3px,color:#000
            style B fill:#ffb74d,stroke:#e65100,stroke-width:2px,color:#000
            style C fill:#ffb74d,stroke:#e65100,stroke-width:2px,color:#000
            style D fill:#ba68c8,stroke:#4a148c,stroke-width:2px,color:#000
            style E fill:#f06292,stroke:#ad1457,stroke-width:2px,color:#000
            style F fill:#ffb74d,stroke:#e65100,stroke-width:2px,color:#000
            style G fill:#ef5350,stroke:#c62828,stroke-width:2px,color:#fff
            style H fill:#ef5350,stroke:#c62828,stroke-width:2px,color:#fff
            style I fill:#ba68c8,stroke:#4a148c,stroke-width:2px,color:#000
            style J fill:#81c784,stroke:#2e7d32,stroke-width:3px,color:#000
            style K fill:#ffab91,stroke:#bf360c,stroke-width:3px,color:#000
        ),
        code_files: get_code_files_for_demo("order_cancellation")
      }
    ]

    respond_to do |format|
      format.html # Will render app/views/bobs_game_store/index.html.erb
      format.json do
        render json: {
          store: "Bob's Game Store",
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
    workflow_result = start_workflow(SimplePurchaseWorkflow, order_params)

    @result = {
      demo: "Simple Purchase",
      description: "Basic purchase with payment and confirmation email",
      workflow_id: workflow_result[:workflow_id],
      order_params: order_params,
      status: workflow_result[:status]
    }

    respond_to do |format|
      format.html { render :result }
      format.json { render json: @result }
    end
  end

  def order_cancellation
    order_params = extract_order_params

    # Add cancellation window (default to 1 minute for demo)
    cancellation_minutes = params[:cancellation_minutes]&.to_i || 1
    order_params["cancellation_window_seconds"] = cancellation_minutes * 60

    workflow_result = start_workflow(OrderCancellationWorkflow, order_params)

    @result = {
      demo: "Order Cancellation with Compensation",
      description: "Complete purchase with #{cancellation_minutes} minute cancellation window. Shows compensating actions if cancelled.",
      workflow_id: workflow_result[:workflow_id],
      order_params: order_params,
      cancellation_minutes: cancellation_minutes,
      status: workflow_result[:status]
    }

    respond_to do |format|
      format.html { render :result }
      format.json { render json: @result }
    end
  end


  def workflow_status
    workflow_id = params[:workflow_id]

    begin
      handle = TemporalClient.client.get_workflow_handle(workflow_id)

      # Try to get the result (this will be nil if still running)
      result = handle.result rescue nil

      render json: {
        workflow_id: workflow_id,
        status: result ? "completed" : "running",
        result: result,
        checked_at: Time.current.iso8601
      }
    rescue => e
      render json: {
        workflow_id: workflow_id,
        status: "error",
        error: e.message,
        checked_at: Time.current.iso8601
      }
    end
  end

  private

  def extract_order_params
    {
      "customer_email" => params[:customer_email] || "customer@example.com",
      "product" => params[:product] || "Nintendo Switch 2",
      "amount" => params[:amount] || 399.99
    }
  end

  def get_code_files_for_demo(demo_type)
    case demo_type
    when "simple_purchase"
      [
        {
          name: "Workflow",
          filename: "simple_purchase_workflow.rb",
          path: "app/workflows/simple_purchase_workflow.rb",
          content: read_file_safely("app/workflows/simple_purchase_workflow.rb")
        },
        {
          name: "Process Payment",
          filename: "process_payment_activity.rb",
          path: "app/activities/process_payment_activity.rb",
          content: read_file_safely("app/activities/process_payment_activity.rb")
        },
        {
          name: "Send Confirmation",
          filename: "send_confirmation_email_activity.rb",
          path: "app/activities/send_confirmation_email_activity.rb",
          content: read_file_safely("app/activities/send_confirmation_email_activity.rb")
        }
      ]
    when "order_cancellation"
      [
        {
          name: "Workflow",
          filename: "order_cancellation_workflow.rb",
          path: "app/workflows/order_cancellation_workflow.rb",
          content: read_file_safely("app/workflows/order_cancellation_workflow.rb")
        },
        {
          name: "Payment Activity",
          filename: "payment_activity.rb",
          path: "app/activities/payment_activity.rb",
          content: read_file_safely("app/activities/payment_activity.rb")
        },
        {
          name: "Reserve Inventory",
          filename: "reserve_inventory_activity.rb",
          path: "app/activities/reserve_inventory_activity.rb",
          content: read_file_safely("app/activities/reserve_inventory_activity.rb")
        },
        {
          name: "Send Confirmation",
          filename: "send_confirmation_email_activity.rb",
          path: "app/activities/send_confirmation_email_activity.rb",
          content: read_file_safely("app/activities/send_confirmation_email_activity.rb")
        },
        {
          name: "Process Refund",
          filename: "process_refund_activity.rb",
          path: "app/activities/process_refund_activity.rb",
          content: read_file_safely("app/activities/process_refund_activity.rb")
        },
        {
          name: "Restock Inventory",
          filename: "restock_inventory_activity.rb",
          path: "app/activities/restock_inventory_activity.rb",
          content: read_file_safely("app/activities/restock_inventory_activity.rb")
        },
        {
          name: "Send Cancellation",
          filename: "send_cancellation_email_activity.rb",
          path: "app/activities/send_cancellation_email_activity.rb",
          content: read_file_safely("app/activities/send_cancellation_email_activity.rb")
        },
        {
          name: "Ship Order",
          filename: "ship_order_activity.rb",
          path: "app/activities/ship_order_activity.rb",
          content: read_file_safely("app/activities/ship_order_activity.rb")
        }
      ]
    else
      []
    end
  end

  def read_file_safely(file_path)
    full_path = Rails.root.join(file_path)
    if File.exist?(full_path)
      File.read(full_path)
    else
      "# File not found: #{file_path}"
    end
  end

  def start_workflow(workflow_class, params)
    workflow_id = "#{workflow_class.name.underscore}_#{SecureRandom.hex(8)}"

    begin
      # Start the Temporal workflow
      handle = TemporalClient.client.start_workflow(
        workflow_class,
        params,
        id: workflow_id,
        task_queue: TemporalClient.task_queue
      )

      {
        workflow_id: workflow_id,
        workflow_class: workflow_class.name,
        started_at: Time.current.iso8601,
        status: "started"
      }
    rescue => e
      Rails.logger.error "Failed to start workflow: #{e.message}"

      {
        workflow_id: workflow_id,
        workflow_class: workflow_class.name,
        started_at: Time.current.iso8601,
        status: "failed",
        error: e.message
      }
    end
  end
end
