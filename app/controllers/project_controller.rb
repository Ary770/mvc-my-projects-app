class ProjectController < ApplicationController

  get '/projects' do
    if logged_in?
      @user = current_user
      @projects = @user.projects
      # binding.pry
      erb :'projects/projects'
    else
      redirect to '/login'
    end
  end

  get '/projects/new' do
    if logged_in?
      erb :"projects/create_project"
    else
      redirect '/login'
    end
  end

  post '/projects/new' do
    if logged_in?
      if params[:name] != ""
        user = current_user
        project = user.projects.build(params)
        user.save
        binding.pry
        redirect "/projects/#{project.id}"
      else
        redirect '/tweets/new'
      end
    else
      redirect '/login'
    end
  end

  get '/projects/:id' do
    if logged_in?
      @project = Project.find(params[:id])
      erb :'projects/show_project'
    else
      redirect '/login'
    end
  end

end
