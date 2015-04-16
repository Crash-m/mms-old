class Material < ActiveRecord::Base
  validates :category, presence:true,
            length: { minimum: 1 }

  def self.text_search(query)
    if query.present?
      where("category @@ :q or subcategory @@ :q or measurements @@ :q or product @@ :q or product_number @@ :q or product_description @@ :q or uom @@ :q or vendor @@ :q", q: query)
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

