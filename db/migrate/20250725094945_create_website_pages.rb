class CreateWebsitePages < ActiveRecord::Migration[8.0]
  def change
    create_table :website_pages do |t|
      t.references :website, null: false, foreign_key: true
      t.string :page_type, null: false # 'home', 'about', 'services', 'contact'
      t.string :title
      t.text :content
      t.json :page_data # Store structured page data
      t.boolean :active, default: true
      t.integer :sort_order, default: 0
      t.timestamps
    end

  end
end