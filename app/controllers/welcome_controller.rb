class WelcomeController < ApplicationController

  def index
    flash[:notice] = "早安！你好！"
  end

  def yy
    render layout: 'welcome'
  end
end
