class V1::Api::LeaveRequests::ShowService < V1::ApplicationService

  attr_accessor :object

  def initialize(params, opts = {})
    super
    @object = opts[:object]
  end
  
  def perform
    show_object
  end

  private
  
    def show_object
      @data = object
    end
end