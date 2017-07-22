describe Api::V1::OrdersController do
  describe 'GET #index' do
    before(:each) do
      current_user = FactoryGirl.create :user
      api_authorization_header current_user.auth_token
      orders = FactoryGirl.create_list(:order, 4, user: current_user)
      get :index, user_id: current_user.id
    end

    it 'returns 4 itmes of current user orders' do
      orders_response = json_response
      expect(orders_response[:orders].size).to eq(4)
    end

    it { should respond_with 200 }
  end

  describe 'GET #show' do
    before(:each) do
      current_user = FactoryGirl.create :user
      api_authorization_header current_user.auth_token
      @order = FactoryGirl.create :order, user: current_user
      get :show, user_id: current_user.id, id: @order.id
    end

    it 'returns an order of given order id params and user' do
      order_response = json_response[:order]
      expect(order_response[:id]).to eq(@order.id)
    end

    it { should respond_with 200 }
  end
end