describe Product, 'association' do
  it { is_expected.to have_many(:placements) }
  it { is_expected.to have_many(:orders).through(:placements) }
end

describe Product do
  let(:product) { FactoryGirl.build(:product) }
  subject { product }
  it { should respond_to(:title) }
  it { should respond_to(:price) }
  it { should respond_to(:published) }
  it { should respond_to(:user_id) }

  it { should_not be_published }

  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:price) }
  it { should validate_numericality_of(:price).is_greater_than_or_equal_to(0) }
  it { should validate_presence_of(:user_id) }

  it { should belong_to(:user) }

  describe '.filter_by_title' do
    let!(:product_a){ create(:product, title: 'A plasma TV') }
    let!(:product_b){ create(:product, title: 'Fastest Laptop') }
    let!(:product_c){ create(:product, title: 'CD player') }
    let!(:product_d){ create(:product, title: 'LCD TV') }

    context "when a 'TV' title pattern is sent" do
      it "returns the 2 products matching" do
        expect(Product.filter_by_title("TV").size).to eq(2)
      end

      it "returns the products matching" do
        expect(Product.filter_by_title("TV").sort).to match_array([product_a, product_d])
      end
    end
  end

  describe ".above_or_equal_to_price" do
    let!(:product_a){ create(:product, price: 100) }
    let!(:product_b){ create(:product, price: 50) }
    let!(:product_c){ create(:product, price: 150) }

    it "returns the products which are above or equal to the price" do
      expect(Product.above_or_equal_to_price(100).sort).to match_array([product_a, product_c])
    end
  end

  describe '.below_or_equal_to_price' do
    let!(:product_a){ create(:product, price: 100) }
    let!(:product_b){ create(:product, price: 50) }
    let!(:product_c){ create(:product, price: 150) }

    it "returns the products which are below or equal to the price" do
      expect(Product.below_or_equal_to_price(100).sort).to match_array([product_b, product_a])
    end
  end

  describe '.recent' do
    let!(:product_a){ create(:product) }
    let!(:product_b){ create(:product) }
    let!(:product_c){ create(:product) }

    it 'returns the products in reverse chronological order' do
      expect(Product.recent).to match_array([product_a, product_c, product_b])
    end
  end

  describe '.search' do
    let!(:product_a){ create(:product, price: 100, title: "Plasma tv") }
    let!(:product_b){ create(:product, price: 50, title: "Videogame console") }
    let!(:product_c){ create(:product, price: 150, title: "MP3") }
    let!(:product_d){ create(:product, price: 99, title: "Laptop") }

    context "when title 'videogame' and '100' a min price are set" do
      it "returns an empty array" do
        search_hash = { keyword: "videogame", min_price: 100 }
        expect(Product.search(search_hash)).to be_empty
      end
    end

    context "when title 'tv', '150' as max price, and '50' as min price are set" do
      it "returns the product1" do
        search_hash = { keyword: "tv", min_price: 50, max_price: 150 }
        expect(Product.search(search_hash)).to match_array([product_a]) 
      end
    end

    context "when an empty hash is sent" do
      it "returns all the products" do
        expect(Product.search({})).to match_array([product_a, product_b, product_c, product_d])
      end
    end
  end
end
