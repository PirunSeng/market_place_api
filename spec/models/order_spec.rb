describe Order do
  let(:order) { FactoryGirl.build :order }
  subject { order }

  it { should respond_to(:total) }
  it { should respond_to(:user_id) }

  it { should validate_presence_of(:user_id) }
  # it { should validate_presence_of(:total) }
  # it { should validate_numericality_of(:total).is_greater_than_or_equal_to(0) }

  it { should belong_to :user }
  it { should have_many(:placements) }
  it { should have_many(:products).through(:placements) }
  
  describe '#set_total!' do
    before(:each) do
      product_a = FactoryGirl.create :product, price: 100
      product_b = FactoryGirl.create :product, price: 85

      placement_a = FactoryGirl.build :placement, product: product_a, quantity: 3
      placement_b = FactoryGirl.build :placement, product: product_b, quantity: 15

      @order = FactoryGirl.build :order

      @order.placements << placement_a
      @order.placements << placement_b
    end

    it 'returns total of products ordered' do
      expect{@order.set_total!}.to change{@order.total.to_f}.from(0).to(1575)
    end
  end

  describe '#build_placements_with_product_ids_and_quantities' do
    before(:each) do
      product_a = FactoryGirl.create(:product, price: 100, quantity: 5)
      product_b = FactoryGirl.create(:product, price: 85, quantity: 10)

      @product_ids_and_quantities = [[product_a.id, 2], [product_b.id, 3]]
    end

    it 'builds 2 placements for the order' do
      expect{order.build_placements_with_product_ids_and_quantities(@product_ids_and_quantities)}.to change{order.placements.size}.from(0).to(2)
    end
  end

  describe '#valid?' do
    before(:each) do
      product_a = FactoryGirl.create(:product, price: 100, quantity: 5)
      product_b = FactoryGirl.create(:product, price: 85, quantity: 10)

      placement_a = FactoryGirl.build :placement, product: product_a, quantity: 3
      placement_b = FactoryGirl.build :placement, product: product_b, quantity: 15

      @order = FactoryGirl.build :order

      @order.placements << placement_a
      @order.placements << placement_b
    end
    
    it 'becomes invalid due to insufficient products' do
      expect(@order.valid?).to be_falsey
    end
  end
end
