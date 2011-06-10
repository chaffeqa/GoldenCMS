class Admin::CategoriesController < ApplicationController
  layout 'admin'
  before_filter :check_admin
  before_filter :get_page, :except => [:new, :create, :index]

  def index
    @categories = Category.page(@page).per(@per_page)
    @categories = @categories.order(@sort + " " + @direction) unless @sort.blank?
  end

  
  def new
    @category = Category.new
    @category.build_page(:displayed => true)
  end

  def edit
  end

  def create
    @category = Category.new(params[:category])
    if @category.save
      redirect_to(admin_categories_path, :notice => 'Category was successfully Added.')
    else
      render :action => "new" 
    end
  end

  def update
    if @category.update_attributes(params[:category])
      redirect_to(admin_categories_path, :notice => 'Category was successfully updated.')
    else
      render :action => "edit"
    end
  end

  def destroy
    @category.destroy
    redirect_to(admin_categories_url, :notice => 'Category was successfully destroyed.')
  end
  
  private

  def get_page
    @category = Category.find(params[:id])
    @category.build_page(:displayed => true) unless @category.page
    @page = @category.page
    super
  end

end
