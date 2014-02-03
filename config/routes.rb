SacMiddle::Application.routes.draw do
  
  devise_for :users, :skip => [:registrations, :registerable]
        as :user do
          get "/users/edit" => "registrations#edit", :as => :edit_user_registration
        end

	root to: 'param_vals#index'
	
	resources :users

	resources :param_levels, except: [:new, :create, :update, :destroy, :edit] do
		collection { post :import }
	end

	resources :param_presets, except: [:new, :create, :update, :destroy, :edit] do
		collection { post :import }
	end

	resources :param_vals, except: [:new, :create, :update, :destroy, :edit] do
    collection { post :import }
  end

	resources :groups do
		collection do
			post :import
			delete :destroy
		end
	end

	resources :parameters, except: [:new, :create, :update, :destroy, :edit] do
		collection { post :import }
	end

	resources :uoms, except: [:new, :create, :update, :destroy, :edit] do
		collection { post :import }
	end

	resources :subjects, except: [:new, :create, :update, :destroy, :edit] do
		collection { post :import }
	end

	resources :formulas, except: [:new, :create, :update, :destroy, :edit] do
		collection { post :import }
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

end
