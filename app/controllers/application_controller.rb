class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :gen_firebase_token, :gen_user_id_prefix, :make_chat_user_id
  include SessionsHelper

  # Force signout to prevent CSRF attacks
  def handle_unverified_request
    sign_out
    super
  end
  
  private

  def gen_firebase_token
# Secret for firechattest
    secret = 'ojTssqItvobMdKl2rvyLvEoZKJkIS1x9GpdDHgdi'
logger.info("***** IP Addr/Host: " + request.host)
# Secret for firechatdirecttest
#    secret = "IHx8GajVRQQ5rjoTaxQJ52oliC3Liy2HTHFBsxXo"
    auth_data = {:auth_data => current_user.email.sub(".","_"), :other_auth_data => current_user.name}
    generator = Firebase::FirebaseTokenGenerator.new(secret)
    token = generator.create_token(auth_data, {})
  end

  def gen_user_id_prefix
    if ((request.domain != nil && request.domain.downcase().eql?("localhost")) ||
         request.host.index("192.168") == 0)
      return "local";
    else
      return "remote";
    end
  end

  def make_chat_user_id(user)
    gen_user_id_prefix + "-chat-user-" + user.id.to_s
  end

end
