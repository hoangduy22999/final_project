# frozen_string_literal: true

namespace :ridgepole do
  desc 'Apply database schema'
  task apply: :environment do
    ridgepole('--apply', "-E #{Rails.env}", "--file #{schema_file}")
    Rake::Task['db:schema:dump'].invoke if Rails.env.development?
  end

  desc 'import seed data'
  task seed: :environment do
    path = Rails.root.join("db/seeds/#{Rails.env}.rb")
    path = path.sub(Rails.env, ENV.fetch('RAILS_ENV', 'development')) unless File.exist?(path)

    require path
  end

  private

  def db_dir
    Rails.root.join('db')
  end

  def schema_file
    "#{db_dir}/Schemafile"
  end

  def config_file
    Rails.root.join('config/database.yml')
  end

  def ridgepole(*options)
    command = ['bundle exec ridgepole', "--config #{config_file}"]
    system [command + options].join(' ')
  end
end
