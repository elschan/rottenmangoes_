class MoviesController < ApplicationController

  def index
    @movies = Movie.all
    handle_index_search
  end

  def show
    @movie = Movie.find(params[:id])
  end

  def new
    @movie = Movie.new
  end

  def edit
    @movie = Movie.find(params[:id])
  end

  def create
    @movie = Movie.new(movie_params)
    if @movie.save
      redirect_to movies_path, notice: "#{@movie.title} was submitted successfully!"
    else
      render :new
    end
  end

  def update
    @movie = Movie.find(params[:id])
    if @movie.update_attributes(movie_params)
      redirect_to movie_path(@movie)
    else
      render :edit
    end
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    redirect_to movies_path
  end

protected 

  def movie_params
    params.require(:movie).permit(
      :title,
      :release_date,
      :director,
      :runtime_in_minutes,
      :poster_image_url,
      :poster,
      :description
    )
  end

  def handle_index_search
    @movies = @movies.title_includes(params[:t]) if params[:t].present?
    @movies = @movies.director_includes(params[:d]) if params[:d].present?
    if params[:length].present?
      case params[:length]
      when 'less90'
        @movies = @movies.less_than_90_mins_long
      when '90to120'
        @movies = @movies.from_90_to_120_mins_long
      when '120more'
        @movies = @movies.more_than_120_mins_long
      end
    end
  end

end
