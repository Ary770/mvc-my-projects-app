require './config/environment'
require 'rack-flash'
class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
		set :session_secret, "password_security"
    use Rack::Flash
  end

  get '/' do
    erb :index
  end

  helpers do
		def logged_in?
			!!current_user
		end

		def current_user # User Instance || nil
			@current_user ||= User.find_by(id: session[:user_id])
		end

    def validate_username
      !User.find_by(username: params[:username])
    end
	end

end
