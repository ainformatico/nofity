class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes do |t|
      t.text       :content, null: false
      t.boolean    :public, default: false
      t.string     :idsec
      t.boolean    :deleted, default: false
      t.belongs_to :user, null: false

      t.timestamps
    end
  end
end
