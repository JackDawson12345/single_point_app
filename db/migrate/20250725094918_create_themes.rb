class CreateThemes < ActiveRecord::Migration[8.0]
  def change
    create_table :themes do |t|
      t.string :name, null: false
      t.text :description
      t.string :preview_image
      t.json :template_files # Store theme templates as JSON
      t.json :css_variables # Store customizable CSS variables
      t.boolean :active, default: true
      t.timestamps
    end

  end
end