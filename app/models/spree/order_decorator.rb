Spree::Order.class_eval do

  def find_line_item_by_variant(variant, option_values = [])
    line_items.detect { |line_item| line_item.variant_id == variant.id  && line_item.option_values == option_values }
  end

end
