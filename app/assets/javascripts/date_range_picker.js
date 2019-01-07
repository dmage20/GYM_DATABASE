var date_range_picker;
date_range_picker = function() {
  $('.date-range-picker').each(function(){
    $(this).daterangepicker({
        timePicker: true,
        // singleDatePicker: true,
        timePickerIncrement: 30,
        alwaysShowCalendars: true
    }, function(start, end, label) {
      $('.start_hidden').val(start.format('YYYY-MM-DD HH:mm'));
      // $('.start_hidden').val(picker.startDate.format('YYYY-MM-DD HH:mm'));
      $('.end_hidden').val(end.format('YYYY-MM-DD HH:mm'));
    });
  })
};
$(document).on('turbolinks:load', date_range_picker);
// -------------------------------------
// var date_range_picker;
// date_range_picker = function() {
//   $('.date-range-picker').each(function(){
//     $(this).daterangepicker({
//     timePicker: true,
//     // startDate: moment().startOf('hour'),
//     // endDate: moment().startOf('hour').add(1, 'hour'),
//     startDate: $('.start_hidden').moment(),
//     endDate: $('.end_hidden').moment(),
//     locale: {
//       // format: 'M/DD hh:mm A'
//     }

//     })
//   })
// };
// $(document).on('turbolinks:load', date_range_picker);
