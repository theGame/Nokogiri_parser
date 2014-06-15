class AddRegExpFilter1ToContents < ActiveRecord::Migration
  def change
    add_column :contents, :reg_exp_filter_1, :string
  end
end
