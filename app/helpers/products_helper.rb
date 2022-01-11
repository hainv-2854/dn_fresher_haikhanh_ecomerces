module ProductsHelper
  def show_image product
    if product.image.attached?
      product.image
    else
      "products/default.png"
    end
  end
end
