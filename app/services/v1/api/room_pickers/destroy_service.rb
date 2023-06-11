class V1::Api::RoomPickers::UpdateService < V1::ApplicationService

  attr_accessor :object

  def initialize(params, opts = {})
    super
    @object = opts[:object] 
  end
  
  def perform
    destroy_object
  end

  private
  
    def destroy_object
      raise Api::V1::ApplicationApi::BadRequest, @data.errors.full_messages.join(", ") unless @data = object.destroy
    end
end