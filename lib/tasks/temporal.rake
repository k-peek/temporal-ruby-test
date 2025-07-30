namespace :temporal do
  desc "Start Temporal worker"
  task worker: :environment do
    puts "🎮 Bob's Game Store - Temporal Worker"
    puts "======================================"

    # Load all our workflow and activity classes
    Dir[Rails.root.join("app", "workflows", "*.rb")].each { |f| require f }
    Dir[Rails.root.join("app", "activities", "*.rb")].each { |f| require f }

    TemporalWorker.start
  end

  desc "Show Temporal configuration"
  task config: :environment do
    puts "Temporal Configuration:"
    puts "======================"
    puts "Host: #{TemporalClient.client.target_host}"
    puts "Namespace: #{TemporalClient.client.namespace}"
    puts "Task Queue: #{TemporalClient.task_queue}"
  end
end
