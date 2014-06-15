class AddNumberToContents < ActiveRecord::Migration
  def change
    add_column :contents, :number, :integer
  end
end
