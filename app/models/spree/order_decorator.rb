module Spree
	Order.class_eval do
		# ********************* Association *****************************************
		belongs_to :parent_order, class_name: "Spree::Order", foreign_key: :parent_id
		has_many :children_orders, class_name: "Spree::Order", foreign_key: :parent_id
		# ********************* Methods *********************************************

		def get_recipients
			recipient_arr = []
			if children_orders.present?
				recipient_arr = children_orders.collect(&:recipient_name)
			end
			unless recipient_arr.include?('Me')
				recipient_arr = recipient_arr.push('Me')
			end
			recipient_arr = recipient_arr.push('Recipient')
			return recipient_arr
		end
		
	end
end