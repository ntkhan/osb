Osb::Application.routes.draw do
  match "dashboard" => "dashboard#index"
  resources :payments do
    collection do
      post 'enter_payment'
      put 'update_individual_payment'
    end
  end
  resources :taxes


  match "invoices/preview" => "invoices#preview"

  match "invoices/bulk_actions" => "invoices#bulk_actions"

  match "invoices/filter_invoices" => "invoices#filter_invoices"

  match "invoices/unpaid_invoices" => "invoices#unpaid_invoices"

  match "items/load_item_data" => "items#load_item_data"

  resources :clients


  resources :client_contacts


  devise_for :users, :path_names => { :sign_out => 'logout'}

  devise_scope :user do
    root :to => "devise/sessions#new"
  end

  resources :categories


  resources :items


  resources :recurring_profile_line_items


  resources :recurring_profiles


  resources :invoice_line_items


  resources :invoices do
    resources :invoice_line_items
    #get 'archive_multiple'
  end


  resources :company_profiles


  resources :client_additional_contacts


  resources :client_billing_infos


  resources :clients


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
  root :to => redirect("/payments")

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  match ':controller(/:action(/:id))(.:format)'
end
