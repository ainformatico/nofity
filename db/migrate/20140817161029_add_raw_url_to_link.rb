class AddRawUrlToLink < ActiveRecord::Migration
  def change
    add_column :links, :raw_url, :text, null: false
  end
end
