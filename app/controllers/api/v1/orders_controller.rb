class Api::V1::OrdersController < ApplicationController
  before_action :authenticate_with_token!, only: [:index]
  respond_to :json

  def index
    respond_with current_user.orders, status: 200
  end

  def find_user
    current_user = User.find(params[:user_id])
  end
end
