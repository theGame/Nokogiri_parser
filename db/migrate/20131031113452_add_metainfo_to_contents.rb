class AddMetainfoToContents < ActiveRecord::Migration
  def change
    add_column :contents, :metainfo, :string
  end
end
