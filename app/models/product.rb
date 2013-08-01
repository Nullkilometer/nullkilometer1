class Product < ActiveRecord::Base
	CATEGORY_NAMES = I18n.t("product.category_names")
  
  attr_accessible :category, :point_of_productions

  belongs_to :seller, :polymorphic => true
  has_many :supplies, :dependent => :destroy
  has_many :point_of_productions, :through => :supplies

  scope :with_category, lambda { |category| where(["category = ?", category])}

  validates :category, :presence => true
end