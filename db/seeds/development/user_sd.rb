# frozen_string_literal: true

debug_print __FILE__

print_log('INSERT USER')

districts = District.all.pluck(:id)
