require "temporalio/activity"
class CheckReleaseDateActivity < Temporalio::Activity::Definition
  def execute(product_info)
    product = product_info["product"]
    expected_release = Time.parse(product_info["release_date"])

    puts "📅 Checking release date for #{product}"
    puts "Expected release: #{expected_release}"
    sleep(1)

    # Check if product is actually released (could have delays)
    # 90% chance it's released on time
    released_on_time = rand < 0.9

    if released_on_time
      {
        product: product,
        status: "released",
        actual_release_date: expected_release.iso8601,
        checked_at: Time.current.iso8601
      }
    else
      # Delayed by 1-7 days
      delay_days = rand(1..7)
      new_date = expected_release + delay_days.days

      {
        product: product,
        status: "delayed",
        original_date: expected_release.iso8601,
        new_release_date: new_date.iso8601,
        delay_days: delay_days,
        checked_at: Time.current.iso8601
      }
    end
  end
end
