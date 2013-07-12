Nullkilometer::Application.routes.draw do

  resources :point_of_sales, :defaults => { :format => :json} do
    resources :market_stalls, :only => [:index, :create], :defaults => {:format => :json}
    resources :products, :only => [:index], :defaults => {:format => :json}
  end

  # match "/point_of_sales/:lat/:lon(/:radius)", 
  #         :to => "point_of_sales#index", 
  #         :constraints => {:lat => /\-*\d+.\d+/ , :lon => /\-*\d+.\d+/ , :radius => /\d+/},  
  #         :defaults => {:radius => 20000, :format => :json}

  resources :market_stalls, :defaults => {:format => :json} do
    resources :products, :only => [:index], :defaults => {:format => :json}
  end

  resources :products, :only => [:index], :defaults => {:format => :json}

  get "point_of_sales/:point_of_sale_id/product_category/:category", :to => "products#show", :defaults => {:format => :json} 
  get "market_stalls/:market_stall_id/product_category/:category", :to => "products#show", :defaults => {:format => :json}


  post "point_of_sales/:point_of_sale_id/product_category/:category/point_of_production/:point_of_production_id", 
            :to => "supplies#create", 
            :defaults => {:format => :json} 
  post "market_stalls/:market_stall_id/product_category/:category/point_of_production/:point_of_production_id", 
            :to => "supplies#create", 
            :defaults => {:format => :json}

  resources :point_of_productions, :defaults => {:format => :json}

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => 'home#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
