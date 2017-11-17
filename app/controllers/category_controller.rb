class CategoryController < ApplicationController

  get '/categories' do
    if logged_in?
      @categories = current_user.categories.uniq
      erb :'categories/categories'
    else
      redirect to '/login'
    end
  end

  get '/categories/:id' do
    if logged_in?
      @category = current_user.categories.find(params[:id])
      erb :'categories/show_category'
    else
      redirect '/login'
    end
  end

end
