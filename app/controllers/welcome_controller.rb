class WelcomeController < ApplicationController
  def index
    response.headers['Cache-Control'] = 'public, max-age=300'
  end
end
