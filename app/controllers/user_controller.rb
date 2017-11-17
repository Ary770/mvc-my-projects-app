class UserController < ApplicationController

  get '/signup' do
    if logged_in?
      redirect to '/projects'
    else
      erb :'users/create_user'
    end
  end

  post '/signup' do
    if validate_username
      user = User.new(params)
      if user.save
        session[:user_id] = user.id
        redirect "/projects"
      else
        flash[:message] = "Ooops! Username and password fields cannot be empty."
        redirect "/signup"
      end
    else
      flash[:message] = "Ooops. This username is already taken!"
      redirect "/signup"
    end
  end

  get '/login' do
    if logged_in?
      redirect to '/projects'
    else
      erb :"users/login"
    end
  end

  post "/login" do
    user = User.find_by(:username => params[:username])

    if user && user.authenticate(params[:password])
	    session[:user_id] = user.id
	    redirect "/projects"
    else
      flash[:message] = "Oh snap! Unable to locate user, please try again."
	    redirect "/login"
    end
	end

  get '/logout' do
    if logged_in?
      session.clear
		  redirect "/login"
    else
      redirect "/"
    end
  end

end
