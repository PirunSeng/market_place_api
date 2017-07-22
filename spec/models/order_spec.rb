describe Order do
  let(:order) { FactoryGirl.build :order }
  subject { order }

  it { should respond_to(:total) }
  it { should respond_to(:user_id) }

  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:total) }
  it { should validate_numericality_of(:total).is_greater_than_or_equal_to(0) }

  it { should belong_to :user }
  it { should have_many(:placements) }
  it { should have_many(:products).through(:placements) }
end

describe Order, '#set_total!' do
  before(:each) do
    product_a = FactoryGirl.create :product, price: 100
    product_b = FactoryGirl.create :product, price: 85

    @order = FactoryGirl.build :order, product_ids: [product_a.id, product_b.id]
  end

  it 'returns total of products ordered' do
    expect(@order.set_total!).to eq(185)
  end
end
