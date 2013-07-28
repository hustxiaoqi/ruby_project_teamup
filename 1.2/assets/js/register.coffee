$(document).ready ->
	#$("#l_u_verification_click").bind('click', verification_change)
	$("#l_submit").click ->
		$.ajax {
			url: '/register'
			success: (result)->
				console.log result
				return
			async: true
			type: 'POST'
			data: {
				'r_u_party_name': 'chuangwang'
				'r_u_email': '592030542@qq.com'
				'r_u_pwd': md5('123')
			}
		}
		return true
		#$.ajax {
			#url: '/register'
			#success: (result)->
				#console.log result
				#return
			#async: true
			#type: 'POST'
			#data: {
				#'r_u_party_name': 'chuangwang'
				#'r_u_email': '592030542@qq.com'
				#'r_u_pwd': md5('123')
			#}
		#}
		#return true

		#$.ajax {
			#url: '/register'
			#success: (result)->
				#console.log result
				#return
			#async: true
			#type: 'POST'
			#data: {
				#'r_u_username': 'xiaoxiao'
				#'r_u_email': 'xiao@hustunqiue.com'
				#'r_u_pwd': md5('123')
				#'r_u_pwd_a': md5('123')
				#'r_u_token': '1234'
				#'r_u_time': new Date().getTime()
			#}
		#}
		#return true
	return
