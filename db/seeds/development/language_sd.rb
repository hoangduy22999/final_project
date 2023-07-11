# frozen_string_literal: true

debug_print __FILE__

print_log('INSERT LANGUAGE')

languages_file = File.read(Rails.root.join('db/json/languages.json'))
languages_data = JSON.parse(languages_file)

languages_data = languages_data.map { |language| language.transform_keys{ |key| key.to_s.underscore }}

db_resources = Language.pluck(:code)
missing_resources = reject_skipping_resources(languages_data, db_resources, 'code')
missing_resources&.count&.times { |time| Language.create(missing_resources[time]) }
