// app/javascript/components/autocomplete.js
function autocomplete() {
  document.addEventListener("DOMContentLoaded", function() {
    var flatAddress = document.getElementById('gym_address');

    if (flatAddress) {
      var autocomplete = new google.maps.places.Autocomplete(flatAddress, { types: [ 'geocode' ] });
      google.maps.event.addDomListener(flatAddress, 'keydown', function(e) {
        if (e.key === "Enter") {
          e.preventDefault(); // Do not submit the form on Enter.
        }
      });
    }
    autocomplete.addListener('place_changed', fillInAddress);
    function fillInAddress() {
      var the_form = document.getElementById('new_gym')
      the_form.submit();
    }
  });
}

export { autocomplete };
