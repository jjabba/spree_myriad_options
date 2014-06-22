Deface::Override.new(:virtual_path => "spree/admin/orders/_line_items",
                     :name => "admin_order_line_item_row",
                     :insert_bottom => "td.line-item-name", # replace the first <td> in the row only
                     :partial => "spree/admin/orders/order_details_line_item_row",
                     :disabled => false)

