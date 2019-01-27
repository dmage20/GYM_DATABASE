 function showmeclick() {

   document.addEventListener("DOMContentLoaded", function() {

      const romain = document.querySelectorAll(".card-link .link");
      romain.forEach((image) =>{
          image.addEventListener("click", (event) => {
            var photo_url = event.currentTarget.innerHTML;
            document.getElementById('placehere').src = photo_url;

            var text_to_copy = event.currentTarget.dataset.caption;
            document.getElementById('caption').innerHTML = text_to_copy
            var time = event.currentTarget.dataset.date;
            document.getElementById('date').innerHTML = time
          });

      });

    });

  }

  export { showmeclick };



