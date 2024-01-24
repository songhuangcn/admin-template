# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

return if Rails.env.test?

puts "..."
root_password = SecureRandom.base64(15)
User.admin.find_or_create_by!(id: 1) do |user|
  user.assign_attributes(username: "root", password: root_password, name: "超级管理员")
end
puts "超级管理员创建成功，账户：`root`, 密码：`#{root_password}`"
