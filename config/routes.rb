ChoiceUnits::Application.routes.draw do
  root to: 'units#index', as: 'units'

  get '/filter' => 'units#filtering'

end
