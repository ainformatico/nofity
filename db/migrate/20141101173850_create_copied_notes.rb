class CreateCopiedNotes < ActiveRecord::Migration
  def change
    create_table :copied_notes do |t|
      t.integer :from_user_id, references: :user
      t.integer :to_user_id, references: :user
      t.references :note
      t.references :link
      t.timestamps
    end
  end
end
