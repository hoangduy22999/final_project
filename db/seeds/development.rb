# frozen_string_literal: true

require_relative './seed_pre_load'

include SeedPreLoad

load_seed('district_sd', 'development')
load_seed('department_sd', 'development')
load_seed('user_sd', 'development')
load_seed('time_sheet_sd', 'development')
