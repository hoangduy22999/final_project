# frozen_string_literal: true

module SeedPreLoad
  def reject_skipping_resources(resources, db_resources, skipping_key)
    resources.reject { |record| db_resources.include?(record[skipping_key]) }.map do |obj|
      obj.merge(time_attributes)
    end
  end

  def print_log(message)
    Ibrain::Logger.info("-------LOGGER: #{message}-------")
  end

  def load_seed(filename, prefix = Rails.env)
    load Rails.root.join('db/seeds', prefix, "#{filename}.rb")
  end

  def now
    Time.current
  end

  def time_attributes
    {
      created_at: now,
      updated_at: now
    }
  end

  def time_past
    {
      created_at: Faker::Time.between_dates(from: today - 365, to: today, period: :all),
      updated_at: now
    }
  end

  def debug_print(message)
    Rails.logger.debug(message)
  end

  def load_csv_service(filename)
    # Initizlie xslx service
    master_data_path = Rails.root.join('db/resources/csv', filename)
    CsvService.new(master_data_path)
  end

  def today
    Time.zone.today
  end
end
