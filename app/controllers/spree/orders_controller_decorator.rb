Spree::OrdersController.class_eval do

  def populate
    populator = Spree::OrderPopulator.new(current_order(create_order_if_necessary: true), current_currency)
    
    option_values = (params[:options].present? ? Spree::OptionValue.where(:id => params[:options].values.map(&:to_i)) : [])

    if populator.populate(params[:variant_id], params[:quantity], { :option_values => option_values, :customizations => params[:customizations] })
      current_order.ensure_updated_shipments

      respond_with(@order) do |format|
        format.html { redirect_to cart_path }
      end
    else
      flash[:error] = populator.errors.full_messages.join(" ")
      redirect_to :back
    end
  end
end
