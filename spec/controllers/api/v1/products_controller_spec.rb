describe Api::V1::ProductsController do
  describe 'GET #show' do
    before(:each) do
      @product = FactoryGirl.create :product
      get :show, id: @product.id
    end

    it 'returns the information about a reporter on a hash' do
      product_resonse = json_response[:product]
      expect(product_resonse[:title]).to eq @product.title
    end

    it { should respond_with 200 }
  end

  describe "GET #index" do
    before(:each) do
      @user = FactoryGirl.create(:user, email: FFaker::Internet.email)
      4.times do |_|
        FactoryGirl.create(:product, user_id: @user.id)
      end
      # get :index
    end

    context 'when not receiving product ids' do
      before(:each) do
        get :index
      end
    end

    it "returns 4 records from the database" do
      products_response = json_response[:product]
      expect(products_response[:products].size).to eq(4)
    end

    it 'returns the user object into each product' do
      products_response = json_response[:products]
      products_response.each do |product_response|
        expect(product_response[:user]).to be_present
        expect(product_response).to respond_with 200
      end
    end

    # it { expect(@products_response).to respond_with 200 }

    context "when product_ids parameter is sent" do
      before(:each) do
        @user = FactoryGirl.create :user

        3.times.each do |_|
          FactoryGirl.create :product, user: @user
        end
        get :index, product_ids: @user.product_ids
      end

      it "returns just the products that belong to the user" do
        products_response = json_response[:products]
        products_response.each do |product_response|
          expect(product_response[:user][:email]).to eq(@user.email)
        end
      end
    end
  end

  describe 'POST #create' do
    context "when is successfully created" do
      before(:each) do
        user = FactoryGirl.create :user
        @product_attributes = FactoryGirl.attributes_for :product
        api_authorization_header user.auth_token
        post :create, { user_id: user.id, product: @product_attributes }
      end

      it 'renders json represent to the post product' do
        product_response = json_response[:product]
        expect(product_response[:title]).to eq(@product_attributes[:title])
      end

      it { should respond_with 201 }
    end

    context "when is not created" do
      before(:each) do
        user = FactoryGirl.create :user
        @invalid_product_attributes = { title: FFaker::Product.product_name, price: 'Invalid price' }
        api_authorization_header user.auth_token
        post :create, { user_id: user.id, product: @invalid_product_attributes }
      end

      it 'renders json errors' do
        product_response = json_response
        expect(product_response).to have_key(:errors)
      end

      it 'renders the json errors on why the product could not be created' do
        product_response = json_response
        expect(product_response[:errors][:price]).to include('is not a number')
      end

      it { should respond_with 422 }
    end
  end

  describe 'PUT/PATCH #update' do
    before(:each) do
      @user = FactoryGirl.create :user
      @product = FactoryGirl.create(:product, user_id: @user.id)
      api_authorization_header @user.auth_token
    end
    context 'successfully updated' do
      before(:each) do
        patch :update, { user_id: @user.id, id: @product.id, product: { title: 'Apple' } }
      end
      it 'renders json represent updated product' do
        product_response = json_response[:product]
        expect(product_response[:title]).to eq('Apple')
      end
      it { should respond_with 201 }
    end

    context 'could not update' do
      before(:each) do
        patch :update, { user_id: @user.id, id: @product.id, product: { price: 'Invalid price' } }
      end
      it 'render json errors' do
        product_response = json_response
        expect(product_response).to have_key(:errors)
      end
      it 'renders json errors why the product could not be updated' do
        product_response = json_response
        expect(product_response[:errors][:price]).to include('is not a number')
      end
      it { should respond_with 422 }
    end
  end

  describe 'DELETE #destroy' do
    context 'successfully destroyed' do
      before(:each) do
        @user = FactoryGirl.create :user
        @product = FactoryGirl.create :product, user_id: @user.id
        api_authorization_header @user.auth_token
        delete :destroy, { user_id: @user.id, id: @product.id }
      end

      it { should respond_with 204 }
    end
  end
end