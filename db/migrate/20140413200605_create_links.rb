class CreateLinks < ActiveRecord::Migration
  def change
    create_table :links do |t|
      t.text :url
      t.text :title
      t.text :description
      t.boolean :deleted
      t.references :user, index: true, null: false

      t.timestamps
    end

    create_table :link_notes do |t|
      t.belongs_to :link, unique: true
      t.belongs_to :note, unique: true

      t.timestamps
    end
  end
end
