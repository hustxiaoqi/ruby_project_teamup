$(document).ready ->
	$("#s_submit").click ->
		name= $.trim $("#s_t_t_name").val()
		intro = $.trim $("#s_t_t_intro").val()
		tid = $.trim $("s_t_t_tid").val()
		
		#$.ajax {
			#url: '/settings/team/' + tid
			#success: (result)->
				#console.log result
				#return
			#async: true
			#type: 'POST'
			#data: {
				#'s_p_m_opwd': md5(opwd)
				#'s_p_m_npwd': md5(npwd)
			#}
		#}
		return true
	return
