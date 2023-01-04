# frozen_string_literal: true

debug_print __FILE__

print_log('INSERT DISTRICT AND CITY')

city_json = File.read('./../db/json/tinh_tp.json')
district_json = File.read('./../db/json/quan_huyen.json')
city_data = JSON.parse(city_json).map(&:last)
district_data = JSON.parse(district_json).map(&:last)

attributes = city_data.map do |city|
  code = city['code']
  districts = district_data.select { |district| district['parent_code'].eql?(code) }.map do |district|
    district.slice!('parent_code', 'code', 'type')
  end
  city.slice!('code', 'type').merge(districts_attributes: districts)
end
db_resources = City.pluck(:name)
