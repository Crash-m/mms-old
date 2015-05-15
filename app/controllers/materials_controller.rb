class MaterialsController < ApplicationController
	helper_method :sort_column, :sort_direction
	before_filter :authorize, only: [:import, :new]
	before_filter :authorize_poweruser, only: [:edit, :update, :create]
	before_filter :authorize_admin, only: [:destroy]
	
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
			redirect_to materials_path, :notice => "Successfully created material. #{undo_link}"
		else
			render 'new'
		end
	end

	def update
		@material = Material.find(params[:id])
		
		if @material.update(material_params)
		  redirect_to @material, :notice => "Successfully updated material. #{undo_link}"
		else
		  render 'edit'
		end
	end
	
	def destroy
		@material = Material.find(params[:id])
		@material.destroy
		
		redirect_to materials_path, :notice => "Successfully destroyed material. #{undo_link}"
	end
	
	private
	
	  def undo_link
	    view_context.link_to("undo", revert_version_path(@material.versions.where(nil).last), :method => :post)
	  end
	
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

