class CatRentalRequest < ActiveRecord::Base
  attr_accessible :cat_id, :start_date, :end_date, :status

  validates :status, inclusion: {in: %w(APPROVED DENIED PENDING) }
  validates :cat_id, :start_date, :end_date, presence: true
  validate :overlapping_requests

  belongs_to :cat, class_name: "Cat", foreign_key: :cat_id, primary_key: :id

  before_validation :set_status_pending

  def approve!
    self.update_attributes(status: 'APPROVED')
  end

  def deny!
    self.update_attributes(status: 'DENIED')
  end

  private
  def overlapping_requests
    all_requests = CatRentalRequest.select('*')
      .where("cat_id = ? AND status != ?", self.cat_id, "DENIED")
      .where("start_date <= ? AND end_date >= ?", self.end_date, self.start_date)
      .where("id != ?", self.id)
      .all

    unless all_requests.empty?
      errors[:overlap] << "request overlaps with existing request"
    end
  end

  def set_status_pending
    self.status ||= "PENDING"
  end
end
