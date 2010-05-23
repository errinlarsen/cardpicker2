class WelcomeController < ApplicationController
  has_mobile_fu
  before_filter :authenticate_user!, :except => [:index]
  
  def index
    puts "we are mobile" if is_mobile_device?
    puts "#{request.user_agent}"
    # Mozilla/5.0 (iPhone; U; CPU iPhone OS 3_1_2 like Mac OS X; en-us) AppleWebKit/528.18 (KHTML, like Gecko) Version/4.0 Mobile/7D11 Safari/528.16


  end

end
