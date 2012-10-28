# encoding: utf-8
class AddStaticPages < ActiveRecord::Migration
  def up
    StaticPage.create(:title => 'Čo je ochranná známka?', :content => '') { |s| s.slug = 'co-je-ochranna-znamka' }
  end

  def down
    StaticPage.delete_all
  end
end
