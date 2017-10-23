class WelcomeController < ApplicationController
  def index
  end

  def home
    render layout: 'backgroundstar'
  end
end
