class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @redirect = false

    if params[:ratings]
      session[:ratings] = params[:ratings]
    elsif session[:ratings]
      params[:ratings] = session[:ratings]
      @redirect = true
    end
    if params[:sort]
      session[:sort] = params[:sort]
    elsif session[:sort]
      params[:sort] = session[:sort]
      @redirect = true
    end

    if @redirect
      flash.keep
      redirect_to movies_path(params)
    elsif
      @all_ratings = Movie::get_ratings

      @ratings =
          params[:ratings] ?
              (params[:ratings].is_a?(Array) ? params[:ratings] : params[:ratings].keys) :
              @all_ratings

      @sort = params[:sort]
      @movies = Movie.find_all_by_rating(@ratings ? @ratings : nil, :order => @sort)
    end
  end


  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
