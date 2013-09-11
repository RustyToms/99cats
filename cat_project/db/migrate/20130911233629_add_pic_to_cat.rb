class AddPicToCat < ActiveRecord::Migration
  def change
    add_column :cats, :pic_html, :text
  end
end
