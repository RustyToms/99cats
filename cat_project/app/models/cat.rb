require 'addressable/uri'
require 'JSON'
require 'rest-client'

class Cat < ActiveRecord::Base
  CAT_COLORS = %w(black orange calico white brown grey blue steel striped spotted tan)
  attr_accessible :age, :birth_date, :color, :name, :sex, :pic_html

  before_validation :get_pic

  validates :sex, inclusion: { in: ["M", "F"]}
  validates :age, numericality: true
  validates :color, inclusion: { in: CAT_COLORS, message: "%{value} is not a valid color" }
  validates :age, :birth_date, :color, :name, :sex, presence: true

  has_many :requests, class_name: "CatRentalRequest", foreign_key: :cat_id, primary_key: :id, dependent: :destroy

  def self.cat_colors
    CAT_COLORS.sort
  end

  def get_pic
    request = Addressable::URI.new(
    scheme: "https",
    host: "www.google.com",
    path: "search",
    query_values: {hl: "en", site: "imghp", source:'hp',
      biw: '1920', bih: "1008", q: "#{self.name}+cat"}
    ).to_s

    page = JSON.parse(RestClient.get(request))['results']
    img_arrs = page.scan(/<img.*?>/)
    pic_html = ''
    img_arrs.each do |img_html|
      width = img_html.slice(/width.*?px/).slice(/\d+/).to_i
      height = img_html.slice(/height.*?px/).slice(/\d+/).to_i
      if width > 200 && height > 100
        pic_html = img_html
        break
      end
    end

    self.pic_html = pic_html

  end

end
