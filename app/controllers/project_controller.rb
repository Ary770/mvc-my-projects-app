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
      if params[:project][:name] != "" && !params[:project][:name].nil? && params[:category]
        category = current_user.categories.find_or_create_by(name: params[:category])
        project = current_user.projects.build(params[:project])
        project.category = category
        params[:ideas].each do |idea|
          project.ideas.build(text: idea) if idea != ""
        end
        current_user.save
        flash[:message] = "Successfully created project."
        redirect "/projects/#{project.id}"
      else
        flash[:message] = "Something went wrong, make sure to fill project name and category."
        redirect '/projects/new'
      end
    else
      redirect '/login'
    end
  end

  get '/projects/:id' do
    if logged_in?
      if @project = current_user.projects.find_by(id: params[:id])
       erb :'projects/show_project'
      else
        redirect '/projects'
      end
    else
      redirect '/login'
    end
  end

  get '/projects/:id/edit' do
    if logged_in?
      if @project = current_user.projects.find_by(id: params[:id])
       erb :'projects/show_project'
      else
        redirect '/projects'
      end
    else
      redirect '/login'
    end
  end

  patch '/projects/:id' do
    if logged_in? && current_user
      if params[:name] != "" && params[:category] != ""
        if project = current_user.projects.find_by(id: params[:id])
          category = Category.find_or_create_by(name: params[:category])
          project.update(params[:project])
          project.category = category
          project.ideas.clear
          params[:ideas].each do |idea|
            project.ideas.build(text: idea)
          end
          if project.save
            redirect "/projects/#{project.id}"
          else
            redirect "/projects/#{project.id}/edit"
          end
        else
          redirect '/projects'
        end
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
