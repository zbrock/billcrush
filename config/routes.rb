Billcrush::Application.routes.draw do
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  resources :groups, :except => [:index] do
    resources :members
    resources :transactions, :only => [:create, :destroy]
  end
  
  root :to => "welcome#index"
  
  match '/:name' => 'groups#show', :as => :group
  match '/:name/settings' => 'groups#settings', :as => :group_settings

  namespace :api do
    match '/groups/:name' => "groups#show", :as => :group
  end
end
