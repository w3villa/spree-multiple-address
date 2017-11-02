module Spree
	Order.class_eval do
		# ********************* Association *****************************************
		belongs_to :parent_order, class_name: "Spree::Order", foreign_key: :parent_id
		has_many :children_orders, class_name: "Spree::Order", foreign_key: :parent_id
		# ********************* Methods *********************************************

		
		
	end
end