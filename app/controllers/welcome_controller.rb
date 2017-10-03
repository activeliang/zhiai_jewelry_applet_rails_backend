class WelcomeController < ApplicationController

  def index
    binding.pry
    flash[:notice] = "早安！你好！"
  end

  def yy
    render layout: 'welcome'
  end
end
