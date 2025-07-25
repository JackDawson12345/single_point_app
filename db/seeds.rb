# Add to db/seeds.rb

# Create sample themes
puts "Creating sample themes..."

# Modern Business Theme
modern_theme = Theme.create!(
  name: 'Modern Business',
  description: 'A clean and professional theme perfect for businesses and startups',
  active: true,
  css_variables: {
    'primary_color' => '#007bff',
    'secondary_color' => '#6c757d',
    'accent_color' => '#28a745',
    'accent_hover_color' => '#218838',
    'text_color' => '#333333',
    'background_color' => '#ffffff',
    'navbar_bg' => '#ffffff',
    'footer_bg' => '#2c3e50',
    'footer_text' => '#ffffff',
    'font_family' => 'Roboto, sans-serif'
  },
  template_files: {
    'home' => 'modern_business_home',
    'about' => 'modern_business_about',
    'services' => 'modern_business_services',
    'contact' => 'modern_business_contact'
  }
)

# Creative Portfolio Theme
creative_theme = Theme.create!(
  name: 'Creative Portfolio',
  description: 'Perfect for artists, designers, and creative professionals',
  active: true,
  css_variables: {
    'primary_color' => '#e74c3c',
    'secondary_color' => '#34495e',
    'accent_color' => '#f39c12',
    'accent_hover_color' => '#e67e22',
    'text_color' => '#2c3e50',
    'background_color' => '#ecf0f1',
    'navbar_bg' => '#ffffff',
    'footer_bg' => '#34495e',
    'footer_text' => '#ecf0f1',
    'font_family' => 'Montserrat, sans-serif'
  },
  template_files: {
    'home' => 'creative_portfolio_home',
    'about' => 'creative_portfolio_about',
    'services' => 'creative_portfolio_services',
    'contact' => 'creative_portfolio_contact'
  }
)

# Minimalist Theme
minimalist_theme = Theme.create!(
  name: 'Minimalist',
  description: 'Clean, simple design focused on content and readability',
  active: true,
  css_variables: {
    'primary_color' => '#2c3e50',
    'secondary_color' => '#95a5a6',
    'accent_color' => '#3498db',
    'accent_hover_color' => '#2980b9',
    'text_color' => '#2c3e50',
    'background_color' => '#ffffff',
    'navbar_bg' => '#f8f9fa',
    'footer_bg' => '#f8f9fa',
    'footer_text' => '#2c3e50',
    'font_family' => 'Georgia, serif'
  },
  template_files: {
    'home' => 'minimalist_home',
    'about' => 'minimalist_about',
    'services' => 'minimalist_services',
    'contact' => 'minimalist_contact'
  }
)

puts "Created #{Theme.count} themes"

# Update existing users or create sample users if they don't exist
if User.find_by(email: 'admin@local.com').nil?
  # Create admin user
  admin = User.create!(
    email: 'admin@local.com',
    password: 'password123',
    password_confirmation: 'password123',
    admin: true
  )
  puts "Created admin user: admin@local.com"
end

if User.find_by(email: 'user@local.com').nil?
  # Create regular user
  user = User.create!(
    email: 'user@local.com',
    password: 'password123',
    password_confirmation: 'password123',
    admin: false
  )
  puts "Created regular user: user@local.com"
end

puts "Database seeded successfully!"
puts ""
puts "Admin credentials:"
puts "Email: admin@local.com"
puts "Password: password123"
puts "Access: Main site + Admin panel (theme management)"
puts ""
puts "User credentials:"
puts "Email: user@local.com"
puts "Password: password123"
puts "Access: Main site + Manage panel (website builder)"
puts ""
puts "Development URLs:"
puts "Main site: http://lvh.me:3000"
puts "Admin panel: http://admin.lvh.me:3000"
puts "Manage panel: http://manage.lvh.me:3000"