// app/javascript/components/autocomplete.js
function autocomplete() {
  document.addEventListener("DOMContentLoaded", function() {
    var flatAddress = document.getElementById('gym_address');

    if (flatAddress) {
      var autocomplete = new google.maps.places.Autocomplete(flatAddress, { types: [ 'geocode' ] });
      google.maps.event.addDomListener(flatAddress, 'keydown', function(e) {
        // console.log();
        if (e.key === "Enter") {
          e.preventDefault(); // Do not submit the form on Enter.
        }
      });
    }
    autocomplete.addListener('place_changed', fillInAddress);
    function fillInAddress() {
      // console.log("hello");
      var the_form = document.getElementById('new_gym')
      // console.log(the_form);
      the_form.submit();
    }
  });
}

export { autocomplete };
