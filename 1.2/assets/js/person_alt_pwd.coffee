$(document).ready ->
	$("#s_submit").click ->
		opwd= $.trim $("#s_p_m_opwd").val()
		npwd = $.trim $("#s_p_m_npwd").val()
		
		$.ajax {
			url: '/settings/person/password'
			success: (result)->
				console.log result
				return
			async: true
			type: 'POST'
			data: {
				's_p_m_opwd': md5(opwd)
				's_p_m_npwd': md5(npwd)
			}
		}
		return true
	return
