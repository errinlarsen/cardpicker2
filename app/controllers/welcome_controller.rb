class WelcomeController < ApplicationController
  has_mobile_fu
  before_filter :authenticate_user!, :except => [:index]
  
  def index
    
  end

end
