class AddImageToProduct < ActiveRecord::Migration
  def change
    add_column :products, :image, :string, default: ''
  end
end
