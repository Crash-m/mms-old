class CreateMaterials < ActiveRecord::Migration
  def change
    create_table :materials do |t|
      t.text :category
      t.text :subcategory
      t.text :measurements
      t.text :product
      t.text :product_number
      t.text :product_description
      t.text :uom
      t.float :price
      t.text :in_stock
      t.text :vendor
      t.float :total
      t.float :markup

      t.timestamps
    end
  end
end
