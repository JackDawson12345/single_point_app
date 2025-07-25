# app/controllers/home_controller.rb
class HomeController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :about]

  def index
  end

  def about
  end
end