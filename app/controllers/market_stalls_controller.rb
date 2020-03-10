class MarketStallsController < ApplicationController
  respond_to :json, :xml, :html

  before_action :market_stall, only: %i[show edit update destroy]
  before_action :generate_form_extras, only: %i[new create]

  def index
    if pos_id = params[:point_of_sale_id] || params[:pointOfSale]
      parent_market(pos_id)
      raise Errors::InvalidPointOfSale, pos_error(pos_id) unless @parent_market.pos_type.zero?

      @market_stalls = @parent_market.market_stalls
    else
      @market_stalls = MarketStall.all
      @market_stalls = @market_stalls.order(params[:sort])
    end
    respond_with @market_stalls
  end

  def show
    respond_with @market_stall
  end

  def new
    puts params
    parent_market(pos_id) if pos_id = params[:point_of_sale_id] || params[:pointOfSale]
    @market_stall = MarketStall.new
    respond_with @market_stall
  end

  def create
    @market_stall = MarketStall.new(record_params)

    @market_stall.pending! if admin_signed_in? == false

    # TODO: remove the if part, cuz there should always be pos_id
    if pos_id = params[:market_stall][:point_of_sale_id]
      parent_market(pos_id)
    end

    if @market_stall.save
      redirect_to @market_stall # @parent_market
    else
      render :new
    end
  end

  def edit
    @product_categories_collection = Product.categories_collection
    @parent_market = @market_stall.point_of_sale
    @status_name = Status.find(@market_stall.status_id).name
    @status_names_collection = Status.names_collection

    respond_with @market_stall
  end

  def update
    prod_cats = params[:market_stall][:productCategoryIds]

    @market_stall.products.each do |product|
      unless prod_cats.include?(product.category.to_s)
        # TODO: change product's attributes in a more "direct" ways
        @market_stall.products_attributes = { id: product.id, _destroy: true }
      end
    end

    # assign pending status only if admin not signed in
    # TODO: commented because would be overwritten in the next step anyway?

    @market_stall.pending!

    if @market_stall.update_attributes!(params[:market_stall])
      flash[:success] = 'Market stall updated successfully'
      # parent_market = @market_stall.point_of_sale
      redirect_to action: 'show', id: @market_stall.id, format: 'html'
    else
      # flash[:error] = "Market stall not updated"
      redirect_to @market_stall
    end
  end

  def destroy
    if @market_stall.destroy
      flash[:success] = 'Market stall destroyed'
      # TODO: redirect to parent market html
      @parent_market = @market_stall.point_of_sale
      redirect_to @parent_market
    else
      # flash[:error] = "Market stall not deleted"
      respond_with @market_stall
    end
  end

  private

  def generate_form_extras
    @product_categories_collection = Product.categories_collection
    @status_names_collection = Status.names_collection
    @parent_market_collection = PointOfSale.market_collection
  end

  def market_stall
    @market_stall = MarketStall.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    raise Errors::InvalidPointOfInterest, "Couldn't find market stall with id=#{params[:id]}"
  end

  def parent_market(id)
    @parent_market = PointOfSale.find(id)
  rescue ActiveRecord::RecordNotFound
    raise Errors::InvalidPointOfSale, "Couldn't find PointOfSale with id=#{id}"
  end

  def record_params
    params.require(:market_stall)
          .permit(
            :name, :point_of_sale_id, :status_id,
            productCategoryIds: []
          )
  end

  def pos_error(pos_id)
    "PointOfSale with id=#{pos_id} is not a Market"
  end
end
