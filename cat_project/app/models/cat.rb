class Cat < ActiveRecord::Base
  CAT_COLORS = %w(black orange calico white brown grey blue steel striped spotted tan)
  attr_accessible :age, :birth_date, :color, :name, :sex

  validates :sex, inclusion: { in: ["M", "F"]}
  validates :age, numericality: true
  validates :color, inclusion: { in: CAT_COLORS, message: "%{value} is not a valid color" }
  validates :age, :birth_date, :color, :name, :sex, presence: true

  has_many :requests, class_name: "CatRentalRequest", foreign_key: :cat_id, primary_key: :id, dependent: :destroy

  def self.cat_colors
    CAT_COLORS.sort
  end

end
