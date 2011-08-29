

$(function() {
    ////////////////////////////////////////////////////////////////////////////
    // Admin View Operations
    var preview = $('a#preview');
    var admin_divs = $('div.admin')
    preview.live('click', function() {
        admin_divs.toggleClass("admin");
    });
    preview.live('click', function() {
        if (preview.text() == 'Preview Page') {
            preview.text('Admin View');
        }
        else {
            preview.text('Preview Page');
        }
    });
    ////////////////////////////////////////////////////////////////////////////
});