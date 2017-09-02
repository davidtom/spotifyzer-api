class ApplicationController < ActionController::API

 def current_user
   #TODO: DELETE BELOW LINE SO WE ALWAYS DEAL WITH THE CURRENT USER
   User.find(2)
  # TODO: SEE ABOVE
 end


end
