class Product < ActiveRecord::Base
  belongs_to :user
  has_many :placements
  has_many :orders, through: :placements

  validates :title, :price, :user_id, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }

  scope :filter_by_title, -> (value) { where('lower(title) LIKE ?', "%#{value.downcase}%") }
  scope :above_or_equal_to_price, -> (value) { where('price >= ?', value) }
  scope :below_or_equal_to_price, -> (value) { where('price <= ?', value) }
  scope :recent, -> { order('created_at desc') }

  def self.search(params = {})
    products = params[:product_ids].present? ? Product.find(params[:product_ids]) : Product.all
    products = products.filter_by_title(params[:keyword]) if params[:keyword]
    products = products.above_or_equal_to_price(params[:min_price].to_f) if params[:min_price]
    products = products.below_or_equal_to_price(params[:max_price].to_f) if params[:max_price]
    products = products.recent(params[:recent]) if params[:recent].present?
    products
  end
end
