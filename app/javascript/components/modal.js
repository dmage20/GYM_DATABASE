 function showmeclick() {

   document.addEventListener("DOMContentLoaded", function() {

      const romain = document.querySelectorAll(".card-link .link");
      romain.forEach((image) =>{
          image.addEventListener("click", (event) => {
            // console.log(event);
            // console.log(event.currentTarget.innerHTML);
            var photo_url = event.currentTarget.innerHTML;
            document.getElementById('placehere').src = photo_url;

            var text_to_copy = event.currentTarget.dataset.caption;
            document.getElementById('caption').innerHTML = text_to_copy
            var time = event.currentTarget.dataset.date;
            document.getElementById('date').innerHTML = time
            // var insta_user = event.currentTarget.dataset.user;
            // document.getElementById('to_instagram').innerHTML = `${insta_user}`
            // document.getElementById('to_instagram').href = `https://www.instagram.com/${insta_user}/`
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

