

$(function() {

$('#other').daterangepicker({
            timePicker : true,
            singleDatePicker:true,
            // timePicker24Hour : true,
            timePickerIncrement : 60,
            // timePickerSeconds : true,
            timePickerMinutes: false,
            minuteselect: false,
            locale : {
                format : 'HH:mm:ss'
            }
        }).on('show.daterangepicker', function(ev, picker) {
            $('.minuteselect').hide();
            picker.container.find(".calendar-table").hide();
   });

  $('#other').on('apply.daterangepicker', function(ev, picker) {
      $('#score_time').val(picker.startDate.format('HH:mm:ss'));
  });



});
