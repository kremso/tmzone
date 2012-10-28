class StaticPagesController < ApplicationController
  def show
    @page = StaticPage.where(slug: params[:slug]).first
    raise ActiveRecord::RecordNotFound unless @page
    @pages = StaticPage.all
    @markdown = Markdown.new(@page.content)
  end
end
