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

      @product = FactoryGirl.create :product
      @order = FactoryGirl.create :order, user: current_user, product_ids: [@product.id]
      get :show, user_id: current_user.id, id: @order.id
    end

    it 'returns an order of given order id params and user' do
      order_response = json_response[:order]
      expect(order_response[:id]).to eq(@order.id)
    end

    it 'includes total for the order' do
      order_response = json_response[:order]
      expect(order_response[:total]).to eq(@order.total.to_s)
    end

    it 'includes products for the order' do
      order_response = json_response[:order]
      expect(order_response[:products].size).to eq(1)
    end

    it { should respond_with 200 }
  end

  describe 'POST #create' do
    describe 'when it is valid' do
      before(:each) do
        current_user = FactoryGirl.create :user
        api_authorization_header current_user.auth_token

        product_a = FactoryGirl.create :product
        product_b = FactoryGirl.create :product
        order_params = { product_ids: [[product_a.id, 2], [product_b.id, 3]] }
        post :create, user_id: current_user.id, order: order_params
      end

      it "returns the just user order record" do
        order_response = json_response[:order]
        expect(order_response[:id]).to be_present
      end

      it 'embeds the two product objects related to the order' do
        order_response = json_response[:order]
        expect(order_response[:products].size).to eq(2)
      end

      it { should respond_with 201 }
    end
  end
end
