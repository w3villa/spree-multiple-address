module Spree
	Order.class_eval do
		# attr_reader :recipient, :recipient_name
		belongs_to :parent_order, class_name: "Spree::Order", foreign_key: :parent_id
		has_many :children_orders, class_name: "Spree::Order", foreign_key: :parent_id
	end
end