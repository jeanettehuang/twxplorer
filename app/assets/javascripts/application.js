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
//= require highcharts
//= require_tree .

function validate() {
  if($("#search").val().length == 0) {
    alert("Looks like you didn't enter a search term!");
    return false;
  }
  return true;
}

$("a.breadcrumbs").click(function() {
  var stopid = $(this).attr("id");
  var oldid = "";
  // $('a.breadcrumbs').first().remove();
  if (stopid == $('.search-input').val()) {
    $.get('/searchedtweets/_makedata?search=' + $('.search-input').val() + '&id=' + stopid + '&stoplistvar=' + $("#stoplist-text").val(), function(response) { $('#main-wrap').html(response);}, 'html');
  }
  $("a.breadcrumbs:not(:first)").each(function() {
    var currentid = $(this).attr("id");
    if (currentid == stopid) {
      oldid += ":" + currentid;
      $.get('/searchedtweets/_makedata?search=' + $('.search-input').val() + '&id=' + oldid + '&stoplistvar=' + $("#stoplist-text").val(), function(response) { $('#main-wrap').html(response);}, 'html');
    }
    else {
      oldid += ":" + currentid;
    }
  });
})


$('a.dropdown-toggle').click(function(event) {
  $('ul#menu1').toggle();  
    // $('ul#menu1').addClass("activeMenu");
})

// $(document).mouseup(function(e){
  // if ($('ul#menu1').hasClass("activeMenu")) {
  //   // $("ul#menu1").removeClass("activeMenu");
  //   $("ul#menu1").toggle();
  // }
//   var container = $("ul#menu1");
//    if (container.has(e.target).length === 0) {
//       container.toggle();
//    }
// })



$(document).ready(function() {
  $("a.inserted-at").click(function() {
    var stoplistvar = "";
    $.get('/searchedtweets/_makedata?search=' + $('.search-input').val() + '&id=' + $('.search-input').val() + '&stoplistvar=' + stoplistvar + '&snapshot=' + $(this).attr("id"), function(response) { $('#main-wrap').html(response);}, 'html');
  });
  $("#stoplist-submit").click(function() {
    var oldid = "";
    $("a.breadcrumbs:not(:first)").each(function() {
      var currentid = $(this).attr("id");
      oldid += ":" + currentid;
    });
    $.get('/searchedtweets/_makedata?search=' + $('.search-input').val() + '&id=' + oldid + '&stoplistvar=' + $("#stoplist-text").val(), function(response) { $('#main-wrap').html(response);}, 'html');
  })
});

