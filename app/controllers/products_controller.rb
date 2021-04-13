class ProductsController < ApplicationController
  before_action :set_product, only: %i[ show edit update destroy checkout]
  before_action :authenticate_user!, except: [:index, :show]


  # GET /projects or /projects.json
  def index
    @products = Product.active
  end

  # GET /projects/1 or /projects/1.json
  def show
    @client_token = Braintree::ClientToken.generate
  end

  # GET /projects/new
  def new
    @product = Product.new
  end

  # GET /products/1/edit
  def edit
  end

  # POST /products or /products.json
  def create
    @product = Product.new(product_params)
    @product.user_id = current_user.id

    respond_to do |format|
      if @product.save
        ExpireProductJob.set(wait_until: @product.expires_at).perform_later(@product)
        format.html { redirect_to @product, notice: "Product was successfully created." }
        format.json { render :show, status: :created, location: @product }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /products/1 or /products/1.json
  def update
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to @product, notice: "Product was successfully updated." }
        format.json { render :show, status: :ok, location: @product }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1 or /products/1.json
  def destroy
    @product.destroy
    respond_to do |format|
      format.html { redirect_to products_url, notice: "Product was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def checkout
    if @product
      nonce = params[:payment_method_nonce]

      result = Braintree::Transaction.sale(
        amount: @product.price,
        payment_method_nonce: nonce
      )

      if result
        redirect_to product_path, notice: "Success!"
      else
        # 錯誤處理
      end
    else
      # 錯誤處理
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def product_params
      params.require(:product).permit(:title, :price, :user_id, :description, :thumbnail, :current_available_amount)
    end
end
