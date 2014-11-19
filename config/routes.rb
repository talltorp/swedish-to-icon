Rails.application.routes.draw do
  get '/icons' => 'icon#list'
  post '/icons' => 'icon#list'
  get '/' => 'main#search'
end
