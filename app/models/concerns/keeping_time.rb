module Concerns::KeepingTime
  extend ActiveSupport::Concern

  included do
    def keeping_checkin_morning
    end

    def keeping_checkin_afternoon
    end

    def keeping_checkout_morning
    end
    
    def keeping_checkout_afternoon
    end
  end
end