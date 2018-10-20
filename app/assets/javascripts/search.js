// document.addEventListener("DOMContentLoaded", function() {
document.addEventListener("turbolinks:load", function() {
  $input = $("[data-behavior='autocomplete']")

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
        console.log(url)
        $.post(url)
        // window.location.reload(true);
        // window.location.href = `${url}`;

      }
    }
  }
  $input.easyAutocomplete(options)
});
