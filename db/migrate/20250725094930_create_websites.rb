class CreateWebsites < ActiveRecord::Migration[8.0]
  def change
    create_table :websites do |t|
      t.references :user, null: false, foreign_key: true
      t.references :theme, null: false, foreign_key: true
      t.string :site_name, null: false
      t.string :domain_slug # for preview URLs
      t.json :customizations # Store user's theme customizations
      t.json :page_content # Store content for each page
      t.boolean :published, default: false
      t.timestamps
    end


  end
end