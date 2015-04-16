class Material < ActiveRecord::Base
  validates :category, presence:true,
            length: { minimum: 1 }

				
	#include PgSearch
	#multisearchable against: [:category, :subcategory, :measurements, :product, :product_number, :product_description, :uom, :price, :in_stock, :vendor, :total]
	
  def self.search(search)
    if search
      where("category like :q or subcategory like :q or measurements like :q or product like :q or product_number like :q or product_description like :q or uom like :q or price like :q or in_stock like :q or vendor like :q or total like :q", q: "%#{search}%")
    else
      default_scoped
    end
  end

  def self.to_csv (options = {})
    CSV.generate(options) do |csv|
    csv << column_names
       all.each do |material|
          csv << material.attributes.values_at(*column_names)
       end
    end
  end
  
  
  def self.import(file)
    spreadsheet = open_spreadsheet(file)
    header = spreadsheet.row(1)
    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      material = find_by_id(row["id"]) || new
      material.attributes = row.to_hash
      material.save!
    end
  end
  
  def self.open_spreadsheet(file)
    case File.extname(file.original_filename)
    when ".csv" then Roo::Csv.new(file.path, nil, :ignore)
    when ".xls" then Roo::Excel.new(file.path, nil, :ignore)
    when ".xlsx" then Roo::Excelx.new(file.path, nil, :ignore)
    else raise "Unknown file type: #{file.original_filename}"
    end
  end
  
  def self.searchable
  end
    
end

