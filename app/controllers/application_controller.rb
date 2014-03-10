class ApplicationController < ActionController::Base
  protect_from_forgery

  include SessionsHelper

  # Force signout to prevent CSRF attacks
  def handle_unverified_request
    sign_out
    super
  end
  
  def gen_firebase_token
# Secret for firechattest
    secret = 'ojTssqItvobMdKl2rvyLvEoZKJkIS1x9GpdDHgdi'

# Secret for firechatdirecttest
#    secret = "IHx8GajVRQQ5rjoTaxQJ52oliC3Liy2HTHFBsxXo"
    auth_data = {:auth_data => current_user.email.sub(".","_"), :other_auth_data => current_user.name}
    generator = Firebase::FirebaseTokenGenerator.new(secret)
    token = generator.create_token(auth_data, {})
  end

end
