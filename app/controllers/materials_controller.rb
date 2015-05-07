class MaterialsController < ApplicationController
	helper_method :sort_column, :sort_direction
	 
	def index
    @materials = Material.text_search(params[:query]).order(sort_column + " " + sort_direction).page(params[:page]).per(25)
		respond_to do |format|
		  format.html
		  format.csv { send_data @materials.to_csv }
		  format.xls #{ send_data @materials.to_csv(col_sep: "\t") }
		end

	end
	
	def edit
		@material = Material.find(params[:id])
	end
	
	def import
    Material.import(params[:file])
    redirect_to materials_path, notice: "Materials imported."
	end
	
	
	def new
		@material = Material.new
	end
	
	def show
		@material = Material.find(params[:id])
	end
	
	def create
		@material = Material.new(material_params)
		
		if @material.save
			redirect_to @material
		else
			render 'new'
		end
	end

	def update
		@material = Material.find(params[:id])
		
		if @material.update(material_params)
		  redirect_to @material
		else
		  render 'edit'
		end
	end
	
	def destroy
		@material = Material.find(params[:id])
		@material.destroy
		
		redirect_to materials_path
	end
	
	private
		def material_params
			params.require(:material).permit(:category, :subcategory, :measurements, :product, :product_number, :product_description, :uom, :price, :in_stock, :vendor, :total, :markup)
		end
		
	  def sort_column
	    Material.column_names.include?(params[:sort]) ? params[:sort] : "id"
	  end
	  
	  def sort_direction
	    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
	  end
end

