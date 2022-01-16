$('#sidebarToggle, #sidebarToggleTop').on('click', function(e) {
  $('body').toggleClass('sidebar-toggled');
  $('.sidebar').toggleClass('toggled');
  if ($('.sidebar').hasClass('toggled')) {
    $('.sidebar .collapse').collapse('hide');
  };
});

// disable button save change if status select is not change or pending
function checkOrderStatusSelect() {
  var initStatus;
  var statusRejected = 3;
  var statusPending = 0;
  var statusInvalid = [statusPending];

  var $formStatus = $('.form-status');
  $formStatus.find('input[type=submit]').prop('disabled', true);
  $formStatus.find('.status-select').one('focus', function() {
    initStatus = this.value;
    statusInvalid[1] = +initStatus;
  }).on('change', function() {
    if(statusInvalid.includes(+this.value)) {
      $(this).parents('.form-status').find('input[type=submit]').prop('disabled', true);
      $(this).addClass('border-danger');
    } else {
      $(this).parents('.form-status').find('input[type=submit]').prop('disabled', false);
      $(this).removeClass('border-danger');
    }
  })
  $formStatus.find('.status-select').on('change', function() {
    if(this.value == statusRejected) {
      $(this).parents('.form-status').find('.reason-rejected').removeClass('d-none');
    } else {
      $(this).parents('.form-status').find('.reason-rejected').addClass('d-none');
    }
  })
}

// delete selected orders
function deleteOrders() {
  $.ajaxSetup({
    headers: {
      'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')
    }
  });
  var $btnDeleteOrders = $('.delete-orders');
  $btnDeleteOrders.click(function() {
    var orderIds = getSelectedCheckbox($('.orders-list'));
    var confirm_msg = 'Are you sure you want to delete the selected orders?';
    console.log('orderIds', orderIds);
    if(orderIds.length > 0 && confirm(confirm_msg)) {
      $.ajax({
        method: 'delete',
        url: 'orders/bulk_order',
        data: { order_ids: orderIds },
        success: function(data) {
          alert('Orders deleted successfully!');
          if(data.rejected_count > 0) {
            $('.btn-rejected .number-order').text(parseInt($('.btn-rejected .number-order').text()) - data.rejected_count);
          }
          if(data.canceled_count > 0) {
            $('.btn-canceled .number-order').text(parseInt($('.btn-canceled .number-order').text()) - data.canceled_count);
          }
          $('.orders-list').find('input[type=checkbox]:checked').closest('tr').fadeOut();
        }
      });
    } else {
      alert('Please select orders to delete');
    }
  });
}

function checkboxAllOrder() {
  var $checkboxAll = $('.checkbox-all-order').find('input[type=checkbox]');
  var $checkboxOrder = $('.orders-list').find('input[type=checkbox]');
  var $checkboxOrderLength = $('.orders-list').find('input[type=checkbox]').length;
  $checkboxAll.on('change', function() {
    if($(this).is(':checked')) {
      $checkboxOrder.prop('checked', true);
    } else {
      $checkboxOrder.prop('checked', false);
    }
  })
  $checkboxOrder.on('change', function() {
    if($(this).is(':checked')) {
      if($(this).closest('tbody').find('input[type=checkbox]:checked').length == $checkboxOrderLength) {
        $checkboxAll.prop('checked', true);
      }
    } else {
      $checkboxAll.prop('checked', false);
    }
  })
}

function getSelectedCheckbox($ordersList){
  var orderIds = [];
  $ordersList.find('input[type=checkbox]:checked').each(function(i, e){
    orderIds.push($(e).val());
  });
  return orderIds;
}

checkOrderStatusSelect();
deleteOrders();
checkboxAllOrder();
