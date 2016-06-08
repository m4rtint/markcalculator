Rails.application.routes.draw do

    #OmniAuth - Facebook
    root 'home#index'

    get 'auth/:provider/callback', to: "sessions#create"
    delete 'sign_out', to: "sessions#destroy", as: 'sign_out'

    #application routes
    get 'term/:tid/courses/:cid' => 'grade#show'
    post 'term/:tid/courses/:cid' => 'grade#post'
    delete 'term/:tid/courses/:cid' => 'grade#destroy', as: :delete_course

    get '/start' => 'start#show'
    post '/start' => 'start#post_first_term'

    get '/term/:tid' => 'term#show_terms'
    post '/term' => 'term#post_terms'
    delete '/term/:tid' => 'term#delete_terms', as: :delete_term

    post '/subjects/:tid' => 'subject#post_subjects'
    delete '/subjects/:id' => 'subject#delete_subjects', as: :delete_subject
    get '/overall/:tid' => 'subject#overall_subjects'

    get '*path', to: 'start#show'

#    <% if current_user %>
#        Signed in as <%= current_user.name %>
#        <%= link_to "Sign Out", 'sign_out', method: :delete %>
#
#    <% else %>
#        <%= link_to "auth/facebook" do %>
#            Sign in facebook
#        <% end %>
#    <% end %>
end
