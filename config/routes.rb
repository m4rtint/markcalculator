Rails.application.routes.draw do
    #OmniAuth - Google
#    get 'auth/:provider/callback', to: 'sessions#create'
#    get 'auth/failure', to: redirect('/')
#    get 'signout', to: 'sessions#destroy', as: 'signout'
#
#    resources :sessions, only: [:create, :destroy]
#    resource :login, only: [:show]
#
#    root to: "login#show"


    #application routes
    get 'term/:tid/courses/:cid' => 'grade#show'
    post 'term/:tid/courses/:cid' => 'grade#post'
    delete 'term/:tid/courses/:cid' => 'grade#destroy', as: :delete_course

    get '/welcome' => 'home#show'
    post '/welcome' => 'home#post_first_term'

    get '/term/:tid' => 'term#show_terms'
    post '/term' => 'term#post_terms'
    delete '/term/:tid' => 'term#delete_terms', as: :delete_term

    post '/subjects/:tid' => 'subject#post_subjects'
    delete '/subjects/:id' => 'subject#delete_subjects', as: :delete_subject
    get '/overall/:tid' => 'subject#overall_subjects'

    get '*path', to: 'home#show'
end
