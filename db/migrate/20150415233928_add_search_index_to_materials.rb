class AddSearchIndexToMaterials < ActiveRecord::Migration
  def up
    execute "create index materials_category on materials using gin(to_tsvector('english', category))"
    execute "create index materials_product_description on materials using gin(to_tsvector('english', product_description))"
    execute "create index materials_vendor on materials using gin(to_tsvector('english', vendor))"
  end
  
  def down
    execute "drop index materials_category"
    execute "drop index materials_product_description"
    execute "drop index materials_vendor"
  end

end
