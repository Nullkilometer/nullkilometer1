module PointOfSalesHelper


  def number_of_pending_selling_points
    pending_status_id = Status.find_by_name('pending').id
    @number_of_pending_selling_points = PointOfSale.where(status_id: pending_status_id).count
  end

   def number_of_pending_market_stalls
    pending_status_id = Status.find_by_name('pending').id
    @number_of_pending_market_stalls = MarketStall.where(status_id: pending_status_id).count
  end


	def updated_product_category_ids pos
	categories = pos.product_category_ids
		if(pos.pos_type == 0)
			pos.market_stalls.each do |stall|
				categories.concat(stall.product_category_ids)
			end
			categories.uniq!
		end
		categories
	end

	def product_category_names pos
		I18n.t("product.category_names").values_at(*pos.product_category_ids)
	end
end
