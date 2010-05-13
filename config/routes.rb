ActionController::Routing::Routes.draw do |map|
  map.devise_for :users
  map.resources :admin, :member => { :reset => [:get, :put] }

  # The following routes allow <game_name>/cards and <game_name>/card_sets/1/edit, etc.
  # The URI's are different, but they still use the underlining Cards and CardSets controllers
  # The ':game' is passed as a parameter ( params[:game] )
  map.with_options( :path_prefix => ":game", :name_prefix => "game_",
      :requirements => { :game => /dominion|startplayer|thunderstone/i }) do |m|
    m.resources :card_sets, :collection => { :random => [:get, :post], :random_options => :get }
    m.resources :cards
  end

  # The following map calls provide routes to cards/ and cards_sets/1/edit, etc.
  #   in other words, if you leave the game name off of the front of the URI, you get here
  map.resources :cards
  map.resources :card_sets

  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  map.root :controller => :card_sets

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing or commenting them out if you're using named routes and resources.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
