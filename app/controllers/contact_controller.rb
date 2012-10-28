# encoding: utf-8

class ContactController < ApplicationController
  def show
  end

  def send_email
    ContactMailer.contact(params[:email], params[:message]).deliver
    redirect_to root_path, notice: 'Budeme Vás kontaktovať s odpoveďou'
  end
end
