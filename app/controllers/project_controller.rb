class ProjectController < ApplicationController

  get '/projects' do
    if logged_in?
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
      if params[:name] != "" && params[:category] &&
        user = current_user
        category = Category.find_or_create_by(name: params[:category])
        project = user.projects.build(params[:project])
        project.category = category
        params[:ideas].each do |idea|
          project.ideas.build(text: idea) if idea != ""
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
      @project = current_user.projects.find(params[:id])
      erb :'projects/show_project'
    else
      redirect '/login'
    end
  end

  get '/projects/:id/edit' do
    if logged_in?
      @project = current_user.projects.find(params[:id])
      erb :"projects/edit"
    else
      redirect '/login'
    end
  end

  patch '/projects/:id' do
    if logged_in? && current_user
      if params[:name] != "" && params[:category] != ""
        project = current_user.projects.find(params[:id])
        category = Category.find_or_create_by(name: params[:category])
        project.update(params[:project])
        project.category = category
        project.ideas.clear
        params[:ideas].each do |idea|
          project.ideas.build(text: idea)
        end
        project.save
        redirect "/projects/#{project.id}"
      else
        redirect "/projects/#{params[:id]}/edit"
      end
    else
      redirect '/login'
    end
  end

  delete '/projects/:id/delete' do
    project = current_user.projects.find(params[:id])
    user = current_user
    if user.projects.include?(project)
      project.delete
      redirect '/projects'
    else
      redirect "/projects"
    end
  end


end
