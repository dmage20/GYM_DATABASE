// document.addEventListener("DOMContentLoaded", function() {

//   document.getElementById("other").onclick = function () {

//   // console.log('hello!');
//   var target = document.getElementById('score_time')
//   target.

//   };

// })

// $(function() {
//    $('#score_time').daterangepicker({
//             timePicker : true,
//             singleDatePicker:true,
//             // timePicker24Hour : true,
//             timePickerIncrement : 60,
//             // timePickerSeconds : true,
//             timePickerMinutes: false,
//             minuteselect: false,
//             locale : {
//                 format : 'HH:mm:ss'
//             }
//         }).on('show.daterangepicker', function(ev, picker) {
//             // $('.minuteselect').hide();
//             picker.container.find(".calendar-table").hide();
//             console.log(picker)
//    });
// })



// $(function() {
// $('#other').mousedown(function(){
// // $('#score_content').val('hello')
//   $('#score_time').visible()
//    $('#score_time').daterangepicker({
//             timePicker : true,
//             singleDatePicker:true,
//             // timePicker24Hour : true,
//             timePickerIncrement : 60,
//             // timePickerSeconds : true,
//             timePickerMinutes: false,
//             minuteselect: false,
//             locale : {
//                 format : 'HH:mm:ss'
//             }
//         }).on('show.daterangepicker', function(ev, picker) {
//             $('.minuteselect').hide();
//             picker.container.find(".calendar-table").hide();
//    });

// })
// })
// document.addEventListener("DOMContentLoaded", function() {
// var something = document.getElementById('other');
// something.addEventListener("click", (event) => {
//   $('#score_time').each(function(){
//    $('#score_time').daterangepicker({
//             timePicker : true,
//             singleDatePicker:true,
//             // timePicker24Hour : true,
//             timePickerIncrement : 60,
//             // timePickerSeconds : true,
//             timePickerMinutes: false,
//             minuteselect: false,
//             locale : {
//                 format : 'HH:mm:ss'
//             }
//         }).on('show.daterangepicker', function(ev, picker) {
//             $('.minuteselect').hide();
//             picker.container.find(".calendar-table").hide();
//    });
// })
//   console.log('start')


// });
// });

// $(function() {
// $('#score_time').click().daterangepicker();
// })
// function myshit () {
//   $('#score_time').daterangepicker();
//   // console.log('hello');
// }

// $(function() {
//   $('#other').click(function(){
//     $(function() {
//       // $('#score_time').daterangepicker();
//       // myshit();
//       $('#other').daterangepicker();
//     })

//   });
// })

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
