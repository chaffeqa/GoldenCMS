$(function() {
    ////////////////////////////////////////////////////////////////////////////
    // For associated model forms
    // Render fields for an associated object
	$('form a.add_child').live('click', function() {
		var assoc = $(this).attr('data-association');
		var content = $('#' + assoc + '_fields_template').html();
		var regexp = new RegExp('new_' + assoc, 'g');
		var new_id = new Date().getTime();
		content=content.replace(regexp, new_id+'');
		$(this).parent().before(content);
		//inputPrompts();
		return false;
	    });
	// Remove fields for new object
	$('form a.remove-new-child').live('click', function() {
		$(this).parents('.child-field').remove();
		return false;
	    });
	// Remove fields for existing object
	$('form a.remove-old-child').live('click', function() {
		var hidden_destroy_field = $(this).next('input.destroy-field');
		hidden_destroy_field.val(1);
		$(this).parents('.child-field').hide();
		return false;
	    });
    // Toggling fields from a select box
    $('.toggle-fields').live('click', function(){
        $("."+$(this).attr('toggle_fields')+":visible").hide();
        $('#'+$(this).attr('toggle_field')).show();
        return true;
    });
    ////////////////////////////////////////////////////////////////////////////
    
    ////////////////////////////////////////////////////////////////////////////
    // Max width your labels
	var max = 0;
	$("label").each(function(){
		if ($(this).width() > max)
		    max = $(this).width();
	    });
	$("label").width(max+15);

	// Generate input prompts
	inputPrompts();

	// Hint Expander
	$(".expander").attr('href','javascript:void(0)');
	$(".expander").live('click', function() {
		$(this).parent().siblings(".expanded-hint").toggle(200, function(){});
	    });
	$(".expanded-hint").hide(); // Hide initially
    ////////////////////////////////////////////////////////////////////////////
    
    ////////////////////////////////////////////////////////////////////////////
    // Dynamic Form Fields Selector
    selector = $(".DynamicFieldsSelector");
    $(".DynamicFields").hide();  // Hide all
    $('.'+selector.val()+'Fields').show(); // Show currently Selected
    selector.change(function() {
        $(".DynamicFields").hide();  // Hide all
        $('.'+$(this).val()+'Fields').show(); // Show currently Selected
    });
    ////////////////////////////////////////////////////////////////////////////
});


function inputPrompts() {
	// Function for forms with inline hints
	$('input[title]:visible').each(function() {
		if($(this).val() === '') {
		    $(this).val($(this).attr('title'));
		}

		$(this).focus(function() {
			if($(this).val() == $(this).attr('title')) {
			    $(this).val('').addClass('focused');
			}
	    });
		$(this).blur(function() {
			if($(this).val() === '') {
			    $(this).val($(this).attr('title')).removeClass('focused');
			}
	    });
    });
}

function stripTitles() {
    $('input[title]').each(function() {
	    if($(this).val() == $(this).attr('title')) {
		$(this).val('');
	    };
	});
}
