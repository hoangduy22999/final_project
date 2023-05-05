class Api::V1::LeaveRequestsController < Api::V1::ApplicationApi
  def index
    render json: {data: current_user.leave_requests}, status: :ok
  end
end