class Movie < ActiveRecord::Base
  scope :title_includes, ->(title_text) { where("title LIKE ?", "%#{title_text}%") }
  scope :director_includes, ->(dir_text) { where("director LIKE ?", "%#{dir_text}%") }
  scope :less_than_90_mins_long, -> { where("runtime_in_minutes < 90") }
  scope :from_90_to_120_mins_long, -> { where("runtime_in_minutes >= 90 AND runtime_in_minutes <= 120") }
  scope :more_than_120_mins_long, -> { where("runtime_in_minutes > 120") }

  has_many :reviews

  mount_uploader :poster, PosterUploader

  validates :title, presence: true
  validates :director, presence: true
  validates :runtime_in_minutes, numericality: { only_integer: true }
  validates :description, presence: true
  # validates :poster_image_url, presence: true
  validates :release_date, presence: true
  # validate :release_date_is_in_the_future

  def review_average
    if !reviews.empty?
      return reviews.sum(:rating_out_of_ten)/reviews.size
    else
      return '-'
    end
  end

protected
  
  # def release_date_is_in_the_future
  #   if release_date.present?
  #     errors.add(:release_date, "should probably be in the future") if release_date < Date.today
  #   end
  # end

end
