class ProductSerializer < ActiveModel::Serializer
  attributes :id, :title, :price, :image, :published
  has_one :user
end
