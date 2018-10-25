class CategoriesController < ApplicationController
  before_action :ensure_category, only: %i[show edit update destroy]

  def index
    @categories = Category.for_user(current_user)
  end

  def show
    @notes = @category.notes
  end

  def create
    defaults = {
      user: current_user
    }
    data = category_params
    data.merge!(defaults)

    render status: 400 unless current_user.categories.create(data)
  end

  def update
    @category.update_attributes(category_params)
  end

  def destroy
    @category.remove
  end

  private

  def ensure_category
    @category = Category.for_user(current_user, params[:id])
  end

  def category_params
    params.require(:category).permit(:name)
  end
end
