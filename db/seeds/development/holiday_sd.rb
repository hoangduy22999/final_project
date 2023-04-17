require 'ruby-holidayapi'

hapi = HolidayAPI::V1.new("5526c7ae-b627-46b1-b4ba-06cc15eccc04")

parameters = {
  # Required
  'country' => 'VN',
  'year'    => 2022,
  # Optional
  # 'month'    => 7,
  # 'day'      => 4,
  # 'previous' => true,
  # 'upcoming' => true,
  # 'public'   => true,
  # 'pretty'   => true,
}

attributes = hapi.holidays(parameters)["holidays"].map do |holiday|
  start_date = Time.now.year.to_s + holiday["date"][4..]
  end_date = Time.now.year.to_s + holiday["observed"][4..]
  {
    name: holiday["name"],
    start_date: start_date,
    end_date: end_date,
    description: holiday["name"],
    status: 1
  }
end

db_resources = Holiday.pluck(:name)
missing_resources = reject_skipping_resources(attributes, db_resources, 'name')
missing_resources.each { |resource| Holiday.create!(resource) }