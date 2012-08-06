// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require_tree .

$(document).ready(function() {
  $('#search').submit(function() {
    var form = $(this);
    $.post(form.attr('action'), form.serialize(), function(results_url) {
      var source = new EventSource(results_url);
      source.addEventListener('results', function(e) {
        var results = $.parseJSON(e.data);

        $('.paging').html("Zobrazujem " + results.status.fetched + " vysledkov z " + results.status.total);
        $.each(results.hits, function(index, result) {
          $('.results').append("<div>" + result.name + "<img src='" + result.illustration_url + "' width='100px'/></div>" );
        });
      });

      source.addEventListener('error', function(e) {
        $('.errors').html("Pri vyhladavani v registroch ochrannych znamok sa vyskytla chyba, vysledky nie su kompletne");
      });
    });

    return false;
  });
});
