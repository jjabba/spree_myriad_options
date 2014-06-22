Spree::OrderContents.class_eval do
  def add(variant, quantity = 1, currency = nil, shipment = nil, options = {})
    line_item = add_to_line_item(variant, quantity, currency, shipment, options)
    reload_totals
    Spree::PromotionHandler::Cart.new(order, line_item).activate
    Spree::ItemAdjustments.new(line_item).update
    reload_totals
    line_item
  end

  private

    def add_to_line_item(variant, quantity, currency=nil, shipment=nil, options = {})
      option_values = options[:option_values]
      line_item = grab_line_item_by_variant(variant, false, option_values)

      if line_item
        line_item.target_shipment = shipment
        line_item.quantity += quantity.to_i
        line_item.currency = currency unless currency.nil?
      else
        line_item = order.line_items.new(quantity: quantity, variant: variant)
        line_item.target_shipment = shipment
        if currency
          line_item.currency = currency
          line_item.price    = variant.price_in(currency).amount
        else
          line_item.price    = variant.price
        end
        
        line_item.option_values = option_values if(option_values.present?)
      end

      line_item.save
      
      if((customizations = options[:customizations]).present?)
        line_item.customizations = customizations
      end

      line_item
    end

    def grab_line_item_by_variant(variant, raise_error = false, option_values = [])
      line_item = order.find_line_item_by_variant(variant, option_values)

      if !line_item.present? && raise_error
        raise ActiveRecord::RecordNotFound, "Line item not found for variant #{variant.sku}"
      end

      line_item
    end
end