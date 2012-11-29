class CategoriesController < ApplicationController

  def index
    @categories = Category.all
    @category   = Category.new
  end

  def create
    @category = Category.new( params[:category])

    respond_to do |format|
      if @category.save
        format.html { redirect_to categories_path, notice: 'category was successfully created.' }
      else
        @categories = Category.all
        format.html { render action: 'index' }
      end
    end

  end
end
