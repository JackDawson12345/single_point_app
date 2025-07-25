# db/seeds.rb
# Create admin user
admin = User.create!(
  email: 'admin@local.com',
  password: 'password123',
  password_confirmation: 'password123',
  admin: true
)

# Create regular user
user = User.create!(
  email: 'user@local.com',
  password: 'password123',
  password_confirmation: 'password123',
  admin: false
)

puts "Created users:"
puts "Admin: admin@local.com (can access main site + admin panel)"
puts "User: user@local.com (can access main site + manage panel)"
puts "Password for all: password123"