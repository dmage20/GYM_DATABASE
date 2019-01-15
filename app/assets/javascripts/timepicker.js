 initialize_timepicker = function() {
  $(function () {
    $('#datetimepicker3').datetimepicker({
      format: 'LT'
    });
    console.log('hello')
  })
};
// $(document).on('turbolinks:load', initialize_timepicker);
