// document.addEventListener("turbolinks:load", function() {




document.addEventListener("DOMContentLoaded", function() {
  $input = $("#basics")

  var options = {
    getValue: "name",
    url: function(phrase){
      return "/search.json?query=" + phrase;
    },
    categories: [
    {
      listLocation: "users",
      header: "<strong>USERS</strong>",
    }
    ],
    list: {

      onChooseEvent: function() {
        var url = $input.getSelectedItemData().url
        // Turbolinks.visit(url)
        // $input.val("")
        // console.log(url)
        $.post(url)

        // $.ajax({
        //   type: "POST",
        //   url: url,
        //   dataType: "html"
        //   });

        // window.location.reload(true);
        // window.location.href = `${url}`;

      }
    }
  }
  $input.easyAutocomplete(options)
});

