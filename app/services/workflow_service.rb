class WorkflowService
  def self.start_workflow(workflow_class, params)
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

  def self.get_status(workflow_id)
    begin
      handle = TemporalClient.client.workflow_handle(workflow_id)

      # Get workflow description to check current status
      description = handle.describe

      # Convert numeric status to string - Temporal uses integers for status
      status_name = case description.status
      when 1
        "running"
      when 2
        "completed"
      when 3
        "failed"
      when 4
        "canceled"
      when 5
        "terminated"
      when 6
        "continued_as_new"
      when 7
        "timed_out"
      else
        "unknown"
      end

      if status_name == "completed"
        # Get the actual result
        result = handle.result
        {
          status: "completed",
          result: result,
          completed_at: description.close_time&.iso8601
        }
      else
        {
          status: status_name
        }
      end
    rescue => e
      Rails.logger.error "Failed to get workflow status: #{e.message}"
      {
        status: "unknown",
        error: e.message
      }
    end
  end
end
