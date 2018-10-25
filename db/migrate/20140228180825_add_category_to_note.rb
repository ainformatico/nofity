class AddCategoryToNote < ActiveRecord::Migration
  def change
    create_table :note_categories do |t|
      t.belongs_to :note, unique: true
      t.belongs_to :category, unique: true

      t.timestamps
    end
  end
end
