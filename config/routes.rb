Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  scope :api do
    scope :exercises do
      get 'next_exercise'  => 'api/exercises#next_exercise',   as: :next_exercise
      get 'check_exercise' => 'api/exercises#check_exercise',  as: :check_exercise
    end
  end
end
