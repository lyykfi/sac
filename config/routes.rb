SacMiddle::Application.routes.draw do

  devise_for :users, :skip => [:registrations, :registerable]
  #   as :user do
  #     get "/users/edit" => "registrations#edit", :as => :edit_user_registration
  #   end

  netzke
  root to: "database_admin#index"
  # root to: 'groups#index'

  get "countries/russia"

  resources :users

  resources :param_levels do
    collection do
      post :import
      delete :destroy
    end
  end

  resources :param_presets do
    collection do
      post :import
      delete :destroy
    end
  end

  resources :param_vals do
    collection do
      post :import
      delete :destroy
    end
  end

  resources :groups do
    collection do
      post :import
      delete :destroy
    end
  end

  resources :parameters do
    collection do
      post :import
      delete :destroy
    end
  end

  resources :uoms do
    collection do
      post :import
      delete :destroy
    end
  end

  resources :subjects, except: [:new, :create, :update, :destroy, :edit] do
    collection { post :import }
  end

  resources :formulas do
    collection do
      post :import
      delete :destroy
    end
  end

  resources :param_refs, except: [:new, :create, :update, :destroy, :edit] do
    collection { post :import }
  end

  resources :param_subjects, except: [:new, :create, :update, :destroy, :edit] do
    collection { post :import }
  end

  resources :events, except: [:new, :create, :update, :destroy, :edit] do
    collection { post :import }
  end

  resources :event_statuses, except: [:new, :create, :update, :destroy, :edit] do
    collection { post :import }
  end

  get "/subjects/:id/parent/" => "subjects#parent"
  get "/subjects/:id/children/" => "subjects#children"
  get "/subjects/:id/subtree/" => "subjects#subtree"
  get "/subjects/:id_parameter/:id/:year/map" => "subjects#show_map"

  get "/countries/" => "subjects#countries"
  get "/districts/" => "subjects#districts"
  get "/regions/" => "subjects#regions"

  get "/param_vals/of_parameter/:param_id" => "param_vals#of_parameter"
  get "/param_vals/of_year/:year" => "param_vals#of_year"
  get "/param_vals/of_subject/:subject_id" => "param_vals#of_subject"
  get "/param_vals/of_subject_with_children/:subject_id" => "param_vals#of_subject_with_children"
  get "/param_vals/of_group/:group_id" => "param_vals#of_group"
  get "/param_vals_of_all_regions/" => "param_vals#of_all_regions"
  get "/param_vals/less_than_date/:date" => "param_vals#less_than_date"
  get "/param_vals/grater_than_date/:date" => "param_vals#grater_than_date"
  get "/param_vals/between/start_date/:start_date/end_date/:end_date" => "param_vals#between_dates"
  get "/available_years/" => "param_vals#available_years"
  get "/cube/" => "param_vals#get_cube"
  get "/cube/:year" => "param_vals#get_cube"

  get "/param_vals/:param_id/:subject_id/:year/" => "param_vals#by_param_id_and_subjects_with_children_and_year"

  get "/groups/:subject_id/:year/" => "groups#by_subject_and_year"
  get "/parameters/:id/:year/" => "parameters#vals_by_id_and_year"
  get "/parameter_names/:subject_ids/:year/" => "parameters#names_by_subject_ids_and_year"
  get "/parameter_names/" => "parameters#names_by_subject_ids_and_year"
  post "/parameter_names/" => "parameters#names_by_subject_ids_and_year"

  get "/parameter_uom/:id/" => "parameters#uom_name_by_id"

  # get "/formats/:subject_ids/:parameter_ids/:year/" => "parameters#table_by_subject_ids_and_parameter_ids_and_year"
  post "/formats/" => "parameters#table_by_subject_ids_and_parameter_ids_and_year"

  # get "/charts/:subject_ids/:parameter_ids/:year1/:year2/" => "parameters#chart_by_subject_ids_and_parameter_ids_and_years"
  # get "/charts/" => "parameters#chart_by_subject_ids_and_parameter_ids_and_years"
  post "/charts/" => "parameters#chart_by_subject_ids_and_parameter_ids_and_years"

  get "/param_levels/:param_id/:subject_id/" => "param_levels#levels"

  get "/districts_params/" => "params#names_by_level", defaults: { level: 1 }
  get "/regions_params/" => "params#names_by_level", defaults: { level: 2 }

  get "/param_values/:param_id/:year/" => "params#vals_by_param_id_and_year"

  get "/param_values/:param_id/:year/map" => "params#map_by_param_id_and_year", defaults: { part: 'central' }
  get "/param_values/:param_id/:year/map-east" => "params#map_by_param_id_and_year", defaults: { part: 'east' }
  get "/param_values/:param_id/:year/map-west" => "params#map_by_param_id_and_year", defaults: { part: 'west' }

end
