$(document).ready(function(){
  $.ajaxSetup({
    headers: {
      'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')
    }
  });

  $('.delete-item-cart').click(function(){
    let $parent = $(this).parents('li');
    let countItemsCart = parseInt($('.count-items-cart').text());
    let totalPriceCart = parseInt($('.total-price-cart').text().replace('.', ''));
    let totalPriceItem = parseInt($parent.find('.total-price-item').text().replace('.', ''));
    let productId = $parent.find('input[name=product_id]').val();
    var confirmation = confirm("are you sure you want to remove the item?");

    if (confirmation) {
      $.ajax({
        method: 'delete',
        url: 'carts/delete',
        data: { product_id: productId },
        success: function(reponsive){
          $('.count-items-cart').text(countItemsCart - 1);
          $('.count-items-cart-hd').text(countItemsCart - 1);
          $('.total-price-cart')
            .text((totalPriceCart - totalPriceItem)
              .toLocaleString()
                .replace(',', '.'));
          $('.alert').remove();
          $parent.remove();
        }
      });
    }
  });

  $('.btn-increase').click(function(){
    let $parent = $(this).parents('li');
    let quantity = parseInt($parent.find('input[name=quantity]').val());
    let productId = $parent.find('input[name=product_id]').val();
    let totalPriceCart = parseInt($('.total-price-cart').text().replace('.', ''));
    let totalPriceItem = parseInt($parent.find('.total-price-item').text().replace('.', ''));
    let priceProduct = parseInt($parent.find('.price-product').text().replace('.', ''));

    $parent.find('input[name=quantity]').val(quantity + 1);
    quantity++;
    using_ajax($parent, quantity, productId, totalPriceCart, totalPriceItem, priceProduct);
  });

  $('.btn-reduce').click(function(){
    let $parent = $(this).parents('li');
    let quantity = parseInt($parent.find('input[name=quantity]').val());
    let productId = $parent.find('input[name=product_id]').val();
    let totalPriceCart = parseInt($('.total-price-cart').text().replace('.', ''));
    let totalPriceItem = parseInt($parent.find('.total-price-item').text().replace('.', ''));
    let priceProduct = parseInt($parent.find('.price-product').text().replace('.', ''));
    if (quantity == 1)
    {
      $parent.find('input[name=quantity]').val(1);
      quantity = 1;
    }
    else
    {
      $parent.find('input[name=quantity]').val(quantity - 1);
      quantity = quantity -1;
    }
    using_ajax($parent, quantity, productId, totalPriceCart, totalPriceItem, priceProduct);
  });

  function using_ajax($parent, quantity, productId, totalPriceCart, totalPriceItem, priceProduct){
    $.ajax({
      method: 'put',
      url: 'carts/' + productId,
      data: { product_id: productId,
              quantity: quantity,
              is_update: 1
            },
      success: function(reponsive){
        $parent.find('.total-price-item')
          .text((priceProduct * quantity)
            .toLocaleString()
              .replace(',', '.'));
        $('.total-price-cart')
          .text((totalPriceCart - totalPriceItem + (priceProduct * quantity))
            .toLocaleString()
              .replace(',', '.'));
        $('.alert').remove();
      }
    });
  }
})
