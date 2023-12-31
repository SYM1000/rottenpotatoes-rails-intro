class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    # if (params[:sort_by].nil? && params[:ratings].nil? && !params.has_key?(:previous_url)) || params.has_key?(:previous_url)
    #   redirect_to movies_path(sort_by: session[:sort_by], ratings: session[:ratings])
    #   return
    # end

    # if params.has_key?(:previous_url)
    #   redirect_to movies_path(sort_by: session[:sort_by], ratings: session[:ratings])
    #   return
    # end

    if params.has_key?(:untick)
      session[:ratings] = params[:ratings]
    end

    if !params[:sort_by].nil?
      session[:sort_by] = params[:sort_by]
      
    end

    params[:ratings] = session[:ratings]

    @all_ratings = Movie.all_ratings
    @ratings_to_show = []
    
    @selected_ratings = session[:ratings]

    

    @selected_ratings = session[:ratings]

    @sort_column = session[:sort_by]
    @title_header_class = @sort_column == 'title' ? 'hilite bg-warning text-primary' : 'text-primary'
    @release_date_header_class = @sort_column == 'release_date' ? 'hilite bg-warning text-primary' : 'text-primary'

    if @selected_ratings == nil || @selected_ratings == []
      @movies = Movie.all.order(@sort_column)
    else
      @movies = Movie.with_ratings(@selected_ratings.keys).order(@sort_column)
    end

    if @selected_ratings != nil
      @ratings_to_show = @selected_ratings.keys
    else
      @ratings_to_show = @all_ratings
    end

    if session[:sort_by] != params[:sort_by] || session[:ratings] != params[:ratings]
      redirect_to movies_path(sort_by: session[:sort_by], ratings: session[:ratings])
    end

  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end
