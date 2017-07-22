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
end


