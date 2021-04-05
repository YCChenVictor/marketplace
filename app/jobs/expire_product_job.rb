class ExpireProductJob < ApplicationJob
  
  queue_as :default

  def perform(product)
    @product = product

    return if product_already_inactive?

    @product.status = "inactive"
    @product.save!
    
    UserMailer.with(product: @product).product_expired_notice.deliver_later

  end

  private
  def product_already_inactive?
    @product.status == "inactive"
  end

end
