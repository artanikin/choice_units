ChoiceUnits::Application.routes.draw do
  root to: 'units#index', as: 'units'

  get '/filter(/:age_from)' => 'units#filtering'

end
