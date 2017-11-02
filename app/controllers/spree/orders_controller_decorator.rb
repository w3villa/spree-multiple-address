Spree::OrdersController.class_eval do

	after_filter :update_child_order, only: [:populate]
	after_filter :empty_child_order, only: [:empty]

	def populate
    @order    = current_order(create_order_if_necessary: true)
    @variant  = Spree::Variant.find(params[:variant_id])
    @quantity = params[:quantity].to_i
    @options  = params[:options] || {}

    # 2,147,483,647 is crazy. See issue #2695.
    if @quantity.between?(1, 2_147_483_647)
      begin
        @order.contents.add(@variant, @quantity, @options)
      rescue ActiveRecord::RecordInvalid => e
        error = e.record.errors.full_messages.join(", ")
      end
    else
      error = Spree.t(:please_enter_reasonable_quantity)
    end

    if error
      flash[:error] = error
      redirect_back_or_default(spree.root_path)
    else
      respond_with(@order) do |format|
        format.html { redirect_to :back }
      end
    end
  end 

  private

  	def update_child_order
  		if params[:recipient] == "Me"
  			recipient = params[:recipient]
  		else
  			recipient = params[:recipient_name].present? ? params[:recipient_name] : params[:recipient]
  		end
  		if @order.children_orders.present?
  			@child_order = Spree::Order.find_by_recipient_name(recipient)
  			if @child_order.present?
  				@child_order.contents.add(@variant, @quantity, @options)
  			else
  				@child_order = Spree::Order.create(parent_id: @order.id, recipient_name: recipient)
  				@child_order.contents.add(@variant, @quantity, @options)
  			end
  		else
  			@child_order = Spree::Order.create(parent_id: @order.id, recipient_name: recipient)
  			@child_order.contents.add(@variant, @quantity, @options)
  		end
  	end

  	def empty_child_order
  		if @order.children_orders.present?
  			@order.children_orders.each do |child_order|
  				child_order.destroy
  			end
  		end
  	end
end
