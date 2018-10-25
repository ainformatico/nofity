class DropLinkNote < ActiveRecord::Migration
  def change
    drop_table :link_notes
  end
end
