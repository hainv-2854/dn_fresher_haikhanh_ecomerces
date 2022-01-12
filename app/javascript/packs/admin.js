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

checkOrderStatusSelect();
