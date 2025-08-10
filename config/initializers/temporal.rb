require "temporalio/client"

Rails.application.configure do
  # Temporal client configuration
  temporal_host = ENV.fetch("TEMPORAL_HOST", "localhost:7233")
  temporal_namespace = ENV.fetch("TEMPORAL_NAMESPACE", "default")

  config.temporal_client = Temporalio::Client.connect(
    temporal_host,
    temporal_namespace
  )

  # Task queue for our workflows
  config.temporal_task_queue = ENV.fetch("TEMPORAL_TASK_QUEUE", "kevins_store")

  # Store connection info for display
  config.temporal_host = temporal_host
  config.temporal_namespace = temporal_namespace
end

# Helper method to access Temporal client
class TemporalClient
  def self.client
    Rails.application.config.temporal_client
  end

  def self.task_queue
    Rails.application.config.temporal_task_queue
  end

  def self.host
    Rails.application.config.temporal_host
  end

  def self.namespace
    Rails.application.config.temporal_namespace
  end
end
