class Cat < ActiveRecord::Base
  attr_accessible :age, :birth_date, :color, :name, :sex

  validates :sex, inclusion: { in: ["M", "F"]}
  validates :age, numericality: true
  validates :color, inclusion: { in: %w(black orange calico white brown grey blue steel striped spotted tan), "%{value} is not a valid color" }
  validates :age, :birth_date, :color, :name, :sex, presence: true
end
