module Spree
	OrderContents.class_eval do 

		def update_cart(params)
			p "called"
      p "111"*20
      p params
      if order.update_attributes(filter_order_items(params))
        p "333"*12
        order.line_items = order.line_items.select { |li| li.quantity > 0 }
        p order.line_items
        # Update totals, then check if the order is eligible for any cart promotions.
        # If we do not update first, then the item total will be wrong and ItemTotal
        # promotion rules would not be triggered.
        persist_totals
        PromotionHandler::Cart.new(order).activate
        order.ensure_updated_shipments
        persist_totals
        true
      else
        p "9999"*23
        false
      end
    end

	end
end