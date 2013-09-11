class CatRentalRequest < ActiveRecord::Base
  attr_accessible :cat_id, :start_date, :end_date, :status
  attr_reader :cat_id, :start_date, :end_date, :status

  validates :status, inclusion: {in: %w(APPROVED DENIED PENDING) }
  validates :cat_id, :start_date, :end_date, :status, presence:true
  validates :overlapping_requests

  belongs_to :cat, class_name: "Cat", foreign_key: :cat_id, primary_key: :id, dependent: :destroy

  before_validation: :set_status_pending

  private
  def overlapping_requests
    all_requests = CatRentalRequests.all.where(":cat_id = ? AND :status != ?", self.cat_id, "DENIED" )

    all_requests.each do |request|
      if self.start_date <= request.end_date && self.end_date >= request.start_date
        errors[:overlap] << "request overlaps with existing request"
      end
    end
  end

  def set_status_pending
    self.status ||= "PENDING"
  end
end
