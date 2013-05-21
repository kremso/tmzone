class Admin::StaticPagesController < ApplicationController
  before_filter :find_page, only: [:edit, :update]

  def index
    @pages = StaticPage.all
  end

  def edit
  end

  def update
    @page.update_attributes(page_params)
    redirect_to admin_static_pages_path
  end

  def find_page
    @page = StaticPage.find(params[:id])
  end

  private

  def page_params
    params.require(:static_page).permit(:title, :content)
  end
end
