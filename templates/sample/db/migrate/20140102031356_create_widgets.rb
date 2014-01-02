class CreateWidgets < ActiveRecord::Migration
  def change
    create_table :widgets do |t|
      t.string :widgets
      t.string :name
      t.string :category
      t.boolean :instock
      t.integer :foo_id
      t.integer :bar_id

      t.timestamps
    end
  end
end
