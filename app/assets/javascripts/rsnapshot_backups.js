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
	var parent = current.parentElement;
	parent.nextSibling.remove();
	parent.previousSibling.remove();
	parent.remove();
});

$(document).on('click', '.close-backup-source-form', function(event) {
	event.preventDefault();
	var current = event.target;
	var parent = current.parentElement;
	parent.style.display = "none";

	var temps = parent.parentElement.getElementsByClassName("temp");
	for(var i=0;i<temps.length;i++){
		temps[i].remove();
	}

	var labels = parent.parentElement.getElementsByClassName("open-backup-source-path");
	for(var i=0;i<labels.length;i++){
		labels[i].style.display="inline-block";
	}
	var fields = parent.parentElement.getElementsByClassName("edit-backup-source-div");
	for(var i=0;i<fields.length;i++){
		fields[i].style.display="none";
	}
	var breaks = parent.parentElement.getElementsByClassName("field-breaks");
	for(var i=0;i<breaks.length;i++){
		//breaks[i].style.display="none";
	}
});

$(document).on('click', '.add-source-path', function(event) {
	var current = event.target;
	var parent = current.parentElement;
	var node = document.createElement('div');
	node.innerHTML = "<div class='open-backup-source-path temp focus' style='background-color: transparent; display: none;'><span></span><br></div> <div class='edit-backup-source-div temp' style='display: inline-block;'><input type='text' name='source_path_input[]' id='source_path_input' value='' placeholder='Select Source Path' class='form-control input-sm increase-length-40' style='display: inline-block; margin-right: 8px;'><img src='/themes/default/images/delete.png' class='delete-source-path' style='cursor: pointer'></div> <br class='field-breaks temp' style='display: inline-block;'>";

	for(var i=0; i< node.childNodes.length; i++){
		parent.parentElement.insertBefore(node.childNodes[i], parent);
	}
});

