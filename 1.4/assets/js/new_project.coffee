$("#p_n_email_btn").click ->
	$("#p_n_email_div").show('slow')
	return
$("#p_n_email_add").click ->
	add_info = '<div><div class="input-prepend"><span class="add-on"><i class="icon-envelope"></i></span><input class="span2" type="text" /></div></div>'
	$(this).parent().prepend(add_info)
	return
