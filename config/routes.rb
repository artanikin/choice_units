ChoiceUnits::Application.routes.draw do
  root to: 'units#index', as: 'units'
  get '/filtered_by' => 'units#filtered'
end
