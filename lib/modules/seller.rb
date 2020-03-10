module Seller
  def self.included base
    base.attr_accessible :productCategoryIds
    base.alias_attribute :productCategoryIds, :product_category_ids
    base.has_many :products, :as => :seller, :dependent => :destroy
    base.accepts_nested_attributes_for :products, :allow_destroy => true, :reject_if => lambda { |pa| pa[:category].blank?}
    base.validate :validate_presence_of_product_categories
    base.class_eval do
      default_scope { includes(:products) }
    end
  end

  def product_category_ids
    @product_category_ids ||= products.map(&:category)
  end

  def product_category_ids=(array)
    array.delete('')
    array.uniq.each do |id|
      unless product_category_ids.include?(id.to_i)
        self.products.build(category: id)
        @product_category_ids << id.to_i
      end
    end
  end

  protected

  def validate_presence_of_product_categories
    if self.products.reject(&:marked_for_destruction?).length < 1
      self.errors.add(:productCategoryIds, I18n.t("validate.messages.product_category_required"))
    end
  end
end
