class MarketStall < ActiveRecord::Base
  has_paper_trail

  attr_accessible :name, :point_of_sale_id, :status_id

  belongs_to :point_of_sale, inverse_of: :market_stalls

  sells_products
  has_detail_infos

  validates :name, presence: true
  validate :point_of_sale_must_be_market, on: :create
  after_validation :log_errors, if: proc { |m| m.errors }

  def pending!
    pending_status_id = Status.find_by_name('pending').id
    self.status_id = pending_status_id
  end

  protected

  def point_of_sale_must_be_market
    return if point_of_sale.pos_type.zero?

    point_of_sale.errors.add(:pos_type, 'Must be a market to have stalls')
  end

  def log_errors
    logger.error "#{name}: " + errors.full_messages.join("\n")
  end
end
