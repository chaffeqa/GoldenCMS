$(function() {
    ////////////////////////////////////////////////////////////////////////////
    // Custom fader for any link. Just add a 'fade'
    // attr with the id of the element you want to fade on the page
    $('a[fade]').live('click', function (e) {
        var divID = $(this).attr('fade');
        $('#'+divID).fadeOut(600);
        e.preventDefault();
    });
    ////////////////////////////////////////////////////////////////////////////
    
    ////////////////////////////////////////////////////////////////////////////
    // Custom flash response to any xhr request
    $("#notice").ajaxComplete(function(e, xhr, settings) {
        flashNotice(xhr);
    });
    $("#error").ajaxComplete(function(e, xhr, settings) {
        flashError(xhr);
    });
    ////////////////////////////////////////////////////////////////////////////
});


// Triggers UI showing of a flash div
function flashNotice(response) {
    msg = response.getResponseHeader("X-Flash-Notice");
    if (msg) {
        $("#notice").slideDown();
        $("#notice > .message").text(msg);
    }
}

// Triggers UI showing of a flash div
function flashError(response) {
    msg = response.getResponseHeader("X-Flash-Error");
    if (msg) {
        $("#error").slideDown();
        $("#error > .message").text(msg);
    }
}
