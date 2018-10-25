class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.text :name, null: false
      t.string :idsec
      t.boolean :deleted, default: false
      t.references :user, index: true, null: false

      t.timestamps
    end
  end
end
