$(document).on('click', '.open-backup-destination-path', function(event) {
	var current = event.target;
	current.style.display = "none";
	var parent = current.parentElement;
	var div = parent.getElementsByClassName("edit-backup-destination-div")[0];
	div.style.display = "inline-block";
});

$(document).on('click', '.close-backup-destination-form', function(event) {
	event.preventDefault();
	var current = event.target;
	var parent = current.parentElement;
	parent.parentElement.style.display = "none";
	var label_span = parent.parentElement.parentElement.getElementsByClassName("open-backup-destination-path")[0];
	label_span.style.display = "inline-block";
});

$(document).on('click', '.open-backup-source-path', function(event) {
        var current = event.target;
        var parent = current.parentElement.parentElement;
        var labels = parent.getElementsByClassName("open-backup-source-path");
	for(var i=0;i<labels.length;i++){
		labels[i].style.display="none";
	}
	var fields = parent.getElementsByClassName("edit-backup-source-div");
	for(var i=0;i<fields.length;i++){
                fields[i].style.display="inline-block";
        }
	var breaks = parent.getElementsByClassName("field-breaks");
        for(var i=0;i<breaks.length;i++){
                breaks[i].style.display="inline-block";
        }
	var control_button_div = parent.parentElement.getElementsByClassName("source-control-buttons")[0];
	control_button_div.style.display="inline-block";
});

$(document).on('click', '.delete-source-path', function(event) {
	var current = event.target;
});

$(document).on('click', '.close-backup-source-form', function(event) {
	var current = event.target;
	var parent = current.parentElement;
	parent.style.display = "none";
	var form_div = parent.parentElement.getElementsByClassName("backup_source_form")[0];
	var labels = form_div.getElementsByClassName("open-backup-source-path");
        for(var i=0;i<labels.length;i++){
                labels[i].style.display="inline-block";
        }
        var fields = form_div.getElementsByClassName("edit-backup-source-div");
        for(var i=0;i<fields.length;i++){
                fields[i].style.display="none";
        }
        var breaks = form_div.getElementsByClassName("field-breaks");
        for(var i=0;i<breaks.length;i++){
 //               breaks[i].style.display="none";
        }
});


