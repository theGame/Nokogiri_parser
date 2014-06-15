class AddEncdingToContents < ActiveRecord::Migration
  def change
    add_column :contents, :encoding, :string
  end
end
