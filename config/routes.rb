Cabooseit::Application.routes.draw do

  # Require for caboose routes to work
  if Caboose::use_comment_routes        
    eval(Caboose::CommentRoutes.controller_routes)      
  end
       
  # Catch everything with caboose
  mount CabooseRets::Engine => '/'
  mount Caboose::Engine => '/'
  match '*path' => 'caboose/pages#show'
  root :to      => 'caboose/pages#show'
  
end
