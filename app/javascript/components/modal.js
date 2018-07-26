 function showmeclick() {

   document.addEventListener("DOMContentLoaded", function() {

      const romain = document.querySelectorAll(".card-link .link");
      romain.forEach((image) =>{
          image.addEventListener("click", (event) => {
            // console.log(event);
            // console.log(event.currentTarget.innerHTML);
            var photo_url = event.currentTarget.innerHTML;
            document.getElementById('placehere').src = photo_url;
            var text_to_copy = event.currentTarget.dataset.texto;
            document.getElementById('instructions').innerHTML = text_to_copy
          });

      });

    });

  }

  export { showmeclick };

// function autocomplete() {
//   document.addEventListener("DOMContentLoaded", function() {
//     var flatAddress = document.getElementById('gym_address');

//     if (flatAddress) {
//       var autocomplete = new google.maps.places.Autocomplete(flatAddress, { types: [ 'geocode' ] });
//       google.maps.event.addDomListener(flatAddress, 'keydown', function(e) {
//         if (e.key === "Enter") {
//           e.preventDefault(); // Do not submit the form on Enter.
//         }
//       });
//     }
//   });
// }

// export { autocomplete };

