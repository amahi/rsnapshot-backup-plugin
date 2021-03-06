
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
	parent.nextSibling.style.display="none";
	current.previousSibling.name="temp-remove"; // to prevent this input from sending via post request
	current.previousSibling.className+=" temp-remove"
	parent.style.display="none";
});

$(document).on('click', '.close-backup-source-form', function(event) {
	event.preventDefault();
	var current = event.target;
	var parent = current.parentElement;
	parent.style.display = "none";

	var temps = parent.parentElement.getElementsByClassName("temp");
	for(var i=temps.length-1;i>=0;i--){
		temps[i].remove();
	}

	var labels = parent.parentElement.getElementsByClassName("open-backup-source-path");
	for(var i=0;i<labels.length;i++){
		labels[i].style.display="inline-block";
		labels[i].style.width="100%";
	}
	var fields = parent.parentElement.getElementsByClassName("edit-backup-source-div");
	for(var i=0;i<fields.length;i++){
		fields[i].style.display="none";
	}
	var breaks = parent.parentElement.getElementsByClassName("field-breaks");
	for(var i=0;i<breaks.length;i++){
		//breaks[i].style.display="none";
	}
	var temp_removes = parent.parentElement.getElementsByClassName("temp-remove");
	for(var i=0;i<temp_removes.length;i++){
		temp_removes[i].parentElement.nextSibling.style.display="inline-block";
		temp_removes[i].name="source_path_input[]";
		temp_removes[i].className=temp_removes[i].className.replace(" temp-remove", "");
	}
});

$(document).on('click', '.add-source-path', function(event) {
	var current = event.target;
	var parent = current.parentElement;
	var node = document.createElement('div');
	node.innerHTML = "<div class='open-backup-source-path temp focus' style='background-color: transparent; width: 100%; display: none;'><span></span><br></div> <div class='edit-backup-source-div temp' style='display: inline-block;'><input type='text' name='source_path_input[]' id='source_path_input' value='' placeholder='Select Source Path' class='form-control input-sm increase-length-40' style='display: inline-block; margin-right: 8px;'><img src='/themes/default/images/delete.png' class='delete-source-path' style='cursor: pointer'></div> <br class='field-breaks temp' style='display: inline-block;'>";

	for(var i=0; i< node.childNodes.length; i++){
		parent.parentElement.insertBefore(node.childNodes[i], parent);
	}
});

$(document).on('ajax:success', '#backup_destination_form_id', function(event, results) {
    // show message temporary
    var messages_span = this.querySelector("#dest_update_messages");
    messages_span.innerHTML = results["message"];

    if(results["success"]){
        messages_span.style.color="green";
        var fixed_span = this.parentElement.previousSibling;
        var edit_text = this.querySelector("#destination_path");
        fixed_span.innerHTML = results["set_path"];
        edit_text.value = results["set_path"];
    }else{
        messages_span.style.color="#a44";
    }

    messages_span.style.display = "inline-block";
    messages_span.style.width = "100%";

    var that=this;
    setTimeout(function() {
        messages_span.style.display="none";
        var cancel_btn = that.querySelector(".close-backup-destination-form");
        cancel_btn.click();

        var fixed_span = that.parentElement.previousSibling;
        var edit_text = that.querySelector("#destination_path");
        edit_text.value=fixed_span.innerHTML;
    }, 4000);

    var spinner = this.querySelector(".dest_update_spinner");
    spinner.style.display="none";
});

function getBackupElement(path){
    var node = document.createElement('div');
	node.innerHTML = "<div class='open-backup-source-path focus'><span>"+path+"</span><br></div> <div class='edit-backup-source-div' style='display: none;'><input type='text' name='source_path_input[]' id='source_path_input_' value='"+path+"' placeholder='Select Source Path' class='form-control input-sm increase-length-40' style='display: inline-block; margin-right: 8px;'><img src='/themes/default/images/delete.png' class='delete-source-path' style='cursor: pointer'></div> <br class='field-breaks' style='display:none;'>";
	return node;
}

$(document).on('ajax:success', '#backup_source_form_id', function(event, results) {
    var messages_span = this.querySelector("#source_update_messages");
    messages_span.innerHTML = results["message"];

    if(results["success"]){
        messages_span.style.color="green";
    }else{
        messages_span.style.color="#a44";
        messages_span.style.width="100%";
    }

    messages_span.style.display="inline-block";

    var that=this;
    setTimeout(function() {
        messages_span.style.display="none";
        var cancel_btn = that.querySelector(".close-backup-source-form");
        cancel_btn.click();

        if(results["success"]){
            var sources = results["sources"];
            while(that.children.length>2){
               that.children[1].remove();
            }

            for(var i=0;i<sources.length;i++){
                var div_element = getBackupElement(sources[i]);
                for(var j=0; j<div_element.childNodes.length; j++){
                    that.insertBefore(div_element.childNodes[j], that.children[that.children.length-1]);
                }
            }
        }else{
            var last_src="";
            for(var i=0;i<that.children.length;i++){
                if(that.childNodes[i].className.indexOf("open-backup-source-path")!=-1){
                    last_src=that.childNodes[i].childNodes[0].innerHTML;
                }else if(that.childNodes[i].className.indexOf("edit-backup-source-div")!=-1){
                    that.childNodes[i].childNodes[0].value=last_src;
                }
            }
        }

    }, 4000);

    var spinner = this.querySelector(".source_update_spinner");
    spinner.style.display="none";
});

$(document).on('ajax:success', '#stop_backup_form_id', function(event, results) {
    var messages_span = this.querySelector("#stop_cron_messages");
    messages_span.innerHTML = results["message"];
    messages_span.style.display="inline-block";
    messages_span.style.color="green";

    setTimeout(function(){
        window.location.reload();
    }, 4000);

    var spinner = this.querySelector(".stop_cron_spinner");
    spinner.style.display="none";
});

$(document).ready(function() {
    $("#backup_destination_submit").click(function() {
      this.previousSibling.style.display = "";
    });
    $("#submit-update-source-paths").click(function() {
      this.previousSibling.style.display = "";
    });
    $("#start_backup_button").click(function() {
      this.previousSibling.style.display = "";
    });
    $("#stop_backup_button").click(function() {
      this.previousSibling.style.display = "";
    });
});

$(document).on('click', '#start_backups_button', function(event) {
    if (confirm('This will start the automatic backups of the folders entered, with the periodicity selected. Are you sure you want to continue?')) {
        var current = event.target;
        current.previousSibling.style.display = "";
        var submit_btn=document.getElementById("start_backups");
        submit_btn.click();
    }
});

$(document).on('click', '#stop_backups_button', function(event) {
    if (confirm('This will stop the automatic backups currenly running. Are you sure you want to continue?')) {
        var current=event.target;
        current.previousSibling.style.display = "";
        var form=document.getElementById("start_backups_form_id");
        var action=form.action;
        action=action.replace("start_backups","stop_backups");
        form.action=action;
        var submit_btn=document.getElementById("start_backups");
        submit_btn.click();
    }
});

$(document).on('ajax:success', '#start_backups_form_id', function(event, results) {
    var messages_span = document.getElementById("start_backups_messages");
    messages_span.innerHTML = results["message"]
    messages_span.style.display="inline-block";

    if(results["success"]){
        messages_span.style.color="green";
    }else{
        messages_span.style.color="#a44";
    }

    setTimeout(function(){
        if(results["success"]){
            window.location.reload();
        }
        messages_span.style.display="none";
    }, 4000);

    var spinner = document.getElementsByClassName("start_backups_spinner")[0];
    spinner.style.display="none";
});

$(document).on('change', '.repeat_duration', function(event, results) {
    var stop_btn = document.getElementById("stop_backups_button");
    if(stop_btn != null){
        this.disabled = true;
        var type = event.target.checked;
        var interval = event.target.value;
        document.getElementById("interval_text").value=interval;
        document.getElementById("update_type").value=type;
        var submit_btn=document.getElementById("update_interval_btn");
        submit_btn.click();

        var spinner = event.target.nextSibling.nextSibling;
        spinner.style.display="";
    }
});

$(document).on('ajax:success', '#update_interval_form_id', function(event, results) {
    var type = results["type"];
    var interval = results["interval"];
    var indexes = {"daily":0, "weekly":1, "monthly":2};
    var spinner = document.getElementsByClassName("interval_spinner")[indexes[interval]];
    spinner.style.display = "none";
    var checkbox = document.getElementsByClassName("repeat_duration")[indexes[interval]];
    checkbox.disabled = false;
    if(type == "true"){
        checkbox.checked = true;
    }else{
        checkbox.checked = false;
    }
});

function getLogElement(log){
    var node = document.createElement('div');
    var count = document.getElementsByClassName("log-details").length;

    var alert_type = "alert-warning";
    if(log["end_message"].indexOf("completed successfully")!=-1){
        alert_type = "alert-success";
    }
    if(log["end_message"].indexOf("error")!=-1 || log["end_message"].indexOf("ERROR")!=-1){
        alert_type = "alert-danger";
    }

    node.innerHTML = "<span class='text-underline h5'>Backup # "+(count+1)+"</span> <br> <div class='alert "+alert_type+" mt-2 log-details' role='alert'><span>Started at: "+log["start_time"]+"</span><span class='text-capitalize float-right'>Type: "+log["type"]+"</span><br><span>Finished at: "+log["end_time"]+"</span><span class='text-capitalize float-right'>Status: "+log["end_message"]+"</span><br></div>";
    return node;
}

$(document).on('click', '#load_more_btn', function(event) {
    var element = event.target.parentElement;
    var next = element.nextSibling;

    if(element){
        element.style.display = "none";
    }
    if(next){
        next.style.display = "";
    }

    var value = document.getElementById("skip_lines_span").innerHTML;

    $.get("/tab/amahi_backups/next_entries?skip_lines="+value, function(data, status){
        if(element){
            element.style.display = "";
        }
        if(next){
            next.style.display = "none";
        }

        if(status=="success"){
            document.getElementById("skip_lines_span").innerHTML = data["skip_lines"];

            if(data["logs"].length<10){
                element.style.display = "none";
            }

            for(var k=0;k<data["logs"].length;k++){
                var log_element = getLogElement(data["logs"][k]);

                for(var j=0; j<log_element.childNodes.length; j++){
                    element.parentElement.parentElement.insertBefore(log_element.childNodes[j], element.parentElement.parentElement.children[element.parentElement.parentElement.children.length-1]);
                }

            }
        }
    });
});
