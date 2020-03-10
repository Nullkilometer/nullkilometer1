class Product < ActiveRecord::Base
  attr_accessible :category, :point_of_productions, :seller_type

  belongs_to :seller, polymorphic: true
  has_many :deliveries, dependent: :destroy
  has_many :point_of_productions, through: :deliveries

  scope :with_category, ->(category) { where(category: category) }

  validates :category, presence: true

  after_validation :log_errors, if: proc { |m| m.errors }

  def log_errors
    logger.error "#{point_of_productions} " + "#{category}: " +
                 errors.full_messages.join("\n")
  end

  def self.category_names
    I18n.t('product.category_names')
  end

  def self.categories_collection
    Product.category_names.each_with_index.map { |name, index| [name, index] }
  end
end
