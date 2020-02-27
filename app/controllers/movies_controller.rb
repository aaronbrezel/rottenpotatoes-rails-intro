class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    
    

    @all_ratings = Movie.get_ratings
    @filter_ratings =  @all_ratings
    
    puts params[:ratings].class

    rating_params = params[:ratings] 
    selected_ratings = []
    
    if !rating_params.nil?
      rating_params.each do |rating, value|
        selected_ratings.push(rating)
      end
      
      @filter_ratings = @filter_ratings.select {|rating| selected_ratings.include? rating}

    end
    
    
    case params[:sort]
    when "alphabet"
      
      @movies = Movie.where(rating: @filter_ratings).order(:title) 
    when "date"
      
      @movies = Movie.where(rating: @filter_ratings).order("release_date DESC") 
    else
      
      @movies = Movie.where(rating: @filter_ratings) #.find_by(rating: params[:ratings])
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

end
