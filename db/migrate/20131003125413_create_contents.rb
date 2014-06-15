class CreateContents < ActiveRecord::Migration
  def change
    create_table :contents do |t|
      t.string :url
      t.string :filter1
      t.string :filter2
      t.string :filter3
      t.integer :timeout
      t.text :description

      t.timestamps
    end
  end
end
