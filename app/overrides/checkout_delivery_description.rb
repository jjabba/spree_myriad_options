Deface::Override.new(:virtual_path => "spree/checkout/_delivery",
                     :name => "checkout_delivery_stock_contents_row",
                     :replace => "table[data-hook=stock-contents] tbody", # replace the first <td> in the row only
                     :partial => "spree/checkout/delivery_stock_contents_row",
                     :disabled => false)

