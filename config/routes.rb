DSMediaLibrary::Engine.routes.draw do
  root to: redirect { |_, req| req.fullpath + "resources" }
  resources :resources do
    put "", on: :collection, action: :move_many
    delete "", on: :collection, action: :destroy
  end
  resources :folders
end

