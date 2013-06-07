// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

// Check for empty search term
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
  console.log("Processing breadcrumbs....");

  if (stopid == $('.search-input').val()) {
      var snapshot = $('#snapshot-string').text();
      if (snapshot == '') {
        console.log("$.get('/searchedtweets/_makedata?search='" + $('.search-input').val() + "'&id='" + oldid + "'&stoplistvar='" + $("#stoplist-text").val() +", function(response) { $('#main-wrap').html(response);}, 'html');");        

        $.get('/searchedtweets/_makedata?search=' + $('.search-input').val() + '&id=' + oldid + '&stoplistvar=' + $("#stoplist-text").val(), function(response) { $('#main-wrap').html(response);}, 'html');
      }
      else {
        console.log("$.get('/searchedtweets/_makedata?search='" + $('.search-input').val() + "'&id='" + oldid + "'&stoplistvar='" + $("#stoplist-text").val() + "'&snapshot='" + snapshot +", function(response) { $('#main-wrap').html(response);}, 'html');");

        $.get('/searchedtweets/_makedata?search=' + $('.search-input').val() + '&id=' + oldid + '&stoplistvar=' + $("#stoplist-text").val() + '&snapshot=' + snapshot, function(response) { $('#main-wrap').html(response);}, 'html');
      }
  }
  $("a.breadcrumbs:not(:first)").each(function() {
    var currentid = $(this).attr("id");
    if (currentid == stopid) {
      oldid += ":" + currentid;

      var snapshot = $('#snapshot-string').text();
      if (snapshot == '') {
        console.log("$.get('/searchedtweets/_makedata?search='" + $('.search-input').val() + "'&id='" + oldid + "'&stoplistvar='" + $("#stoplist-text").val() +", function(response) { $('#main-wrap').html(response);}, 'html');");

        $.get('/searchedtweets/_makedata?search=' + $('.search-input').val() + '&id=' + oldid + '&stoplistvar=' + $("#stoplist-text").val(), function(response) { $('#main-wrap').html(response);}, 'html');
      }
      else {
        console.log("$.get('/searchedtweets/_makedata?search='" + $('.search-input').val() + "'&id='" + oldid + "'&stoplistvar='" + $("#stoplist-text").val() + "'&snapshot='" + snapshot +", function(response) { $('#main-wrap').html(response);}, 'html');");

        $.get('/searchedtweets/_makedata?search=' + $('.search-input').val() + '&id=' + oldid + '&stoplistvar=' + $("#stoplist-text").val() + '&snapshot=' + snapshot, function(response) { $('#main-wrap').html(response);}, 'html');
      }
    }
    else {
      oldid += ":" + currentid;
    }
  });
})

// Fixing dropdown toggling 
$('a.dropdown-toggle').click(function(event) {
  $('ul#menu1').toggle();  
})


$(document).ready(function() {
  $('.modal-backdrop').remove();

  // Snapshots
  $("a.inserted-at").click(function() {
    var stoplistvar = "";
    console.log("Processing Snapshot....");
    console.log("executing get request");
    console.log("$.get('/searchedtweets/_makedata?search='" + $('.search-input').val() + "'&id='" + $('.search-input').val() + "'&stoplistvar='" + stoplistvar + "'&snapshot='" + $(this).attr("id") + ", function(response) { $('#main-wrap').html(response);}, 'html');");

    $.get('/searchedtweets/_makedata?search=' + $('.search-input').val() + '&id=' + $('.search-input').val() + '&stoplistvar=' + stoplistvar + '&snapshot=' + $(this).attr("id"), function(response) { $('#main-wrap').html(response);}, 'html');
  });

// Stoplist  
  $("#stoplist-submit").click(function() {
    var oldid = "";
    console.log("Processing Stoplist....");
    
    $("a.breadcrumbs:not(:first)").each(function() {
      var currentid = $(this).attr("id");
      oldid += ":" + currentid;
    });
    var snapshot = $('#snapshot-string').text();
    if (snapshot == '') {
      console.log("executing get request");
      console.log("$.get('/searchedtweets/_makedata?search='" + $('.search-input').val() + "'&id='" + oldid + "'&stoplistvar='" + $("#stoplist-text").val() + ", function(response) { $('#main-wrap').html(response);}, 'html');");

      $.get('/searchedtweets/_makedata?search=' + $('.search-input').val() + '&id=' + oldid + '&stoplistvar=' + $("#stoplist-text").val(), function(response) { $('#main-wrap').html(response);}, 'html');
    } else {
      console.log("executing get request");
      console.log("$.get('/searchedtweets/_makedata?search='" + $('.search-input').val() + "'&id='" + oldid + "'&stoplistvar='" + $("#stoplist-text").val() + "'&snapshot='" + snapshot + ", function(response) { $('#main-wrap').html(response);}, 'html');");

      $.get('/searchedtweets/_makedata?search=' + $('.search-input').val() + '&id=' + oldid + '&stoplistvar=' + $("#stoplist-text").val() + '&snapshot=' + snapshot, function(response) { $('#main-wrap').html(response);}, 'html');
    }
  })
});