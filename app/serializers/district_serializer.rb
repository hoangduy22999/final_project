# frozen_string_literal: true

class DistrictSerializer
  include JSONAPI::Serializer
  attributes :id, :name
end
