# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

products = [
  { title: 'Apple', price: 12, image: 'https://p7.hiclipart.com/preview/456/10/576/apple-red-delicious-eating-fuji-large-green-leaves-red-apple.jpg' },
  { title: 'Banna', price: 23, image: 'https://images-na.ssl-images-amazon.com/images/I/61fZ%2BYAYGaL._SX425_.jpg' },
  { title: 'Cherry', price: 23, image: 'https://www.visitstockton.org//imager/s3_us-west-1_amazonaws_com/stockton-2019/images/linden-cherry-festival_3fe5642e728110e436c0178eca42c0c1.jpg' },
  { title: 'Dragon Fruit', price: 34, image: 'https://cdn3.volusion.com/kceqm.mleru/v/vspfiles/photos/68-2.jpg?v-cache=1584521450' },
  { title: 'Eggfruit', price: 52, image: 'https://assets.atlasobscura.com/media/W1siZiIsInVwbG9hZHMvdGhpbmdfaW1hZ2VzLzNjYTZlMTE3LThlY2UtNDMwNy1hMDI1LWI3M2FmY2FiYWZjMDlkY2ViNDdkY2Q2NGYyNTg2ZF9FZ2dmcnVpdF9TaHV0dGVyc3RvY2suanBnIl0sWyJwIiwiY29udmVydCIsIiJdLFsicCIsImNvbnZlcnQiLCItcXVhbGl0eSA4MSAtYXV0by1vcmllbnQiXSxbInAiLCJ0aHVtYiIsIjU4MHg1ODAjIl1d/Eggfruit_Shutterstock.jpg' },
  { title: 'Farkleberry', price: 30, image: 'https://cdn11.bigcommerce.com/s-z6b2k4z/product_images/uploaded_images/-farkleberry3.jpg' },
]
products.each do |product|
  Product.find_or_create_by(product)
end
