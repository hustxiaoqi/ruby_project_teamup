verification_change  = ->
	l_u_email = $.trim $("#l_u_email").val()
	$.ajax {
		url: '/login/randomImage'
		success: (result)->
			console.log result
			result = eval '(' + result + ')'
			$("#l_u_verification_html").html('<input type="text" id="l_u_token" placeholder="verify" /><button class="btn btn-link" onclick="verification_change();"><img src="' + result.info + '"/></button>')
			return
		async: true
		type: 'GET'
		data: {
			'l_r_email': l_u_email
			'l_r_time': new Date().getTime()
		}
	}
	return

$(document).ready ->
	##$("#l_u_verification_click").click ->
	#verification_change  = ->
		#l_u_email = $.trim $("#l_u_email").val()
		#$.ajax {
			#url: '/login/randomImage'
			#success: (result)->
				#console.log result
				#result = eval '(' + result + ')'
				#$("#l_u_verification_html").html('<input type="text" id="l_u_token" placeholder="verify" /><button class="btn btn-link" onclick="verification_change();"><img src="' + result.info + '"/></button>')
				#return
			#async: true
			#type: 'GET'
			#data: {
				#'l_r_email': l_u_email
				#'l_r_time': new Date().getTime()
			#}
		#}
		#return

	$("#l_u_verification_click").bind('click', verification_change)
	$("#l_submit").click ->
		l_u_email= $.trim $("#l_u_email").val()
		l_u_pwd = $.trim $("#l_u_pwd").val()
		l_u_token = $.trim $("#l_u_token").val()
		
		$.ajax {
			url: '/login'
			success: (result)->
				console.log result
				return
			async: true
			type: 'POST'
			data: {
				'l_u_email': l_u_email
				'l_u_pwd': md5(l_u_pwd)
				'l_u_token': l_u_token
				'l_u_time': new Date().getTime()
			}
		}
		return true
	return
