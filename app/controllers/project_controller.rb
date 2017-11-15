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
    if logged_in? && current_user
      if params[:name] != "" && params[:category]
        user = current_user
        category = Category.find_or_create_by(name: params[:category])
        project = user.projects.build(params[:project])
        project.category = category
        params[:ideas].each do |idea|
          project.ideas.build(text: idea)
        end
        user.save

        redirect "/projects/#{project.id}"
      else
        redirect '/projects/new'
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
