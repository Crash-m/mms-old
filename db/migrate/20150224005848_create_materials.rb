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
      t.text :price
      t.text :in_stock
      t.text :vendor
      t.text :total

      t.timestamps
    end
  end
end
