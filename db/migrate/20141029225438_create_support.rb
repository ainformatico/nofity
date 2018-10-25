class CreateSupport < ActiveRecord::Migration
  def change
    create_table :supports do |t|
      t.string :email
      t.text :content
    end
  end
end
