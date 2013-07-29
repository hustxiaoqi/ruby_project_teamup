$(document).ready ->
	$("#l_submit").click ->
		s_p_m_name= $.trim $("#s_p_m_name").val()
		s_p_m_brief= $.trim $("#s_p_m_brief").val()
		
		$.ajax {
			url: '/settings/person'
			success: (result)->
				console.log result
				#result = eval('(' + result + ')')
				#window.location = '/team' if result.status is true
				return
			async: true
			type: 'POST'
			data: {
				's_p_m_name': s_p_m_name
				's_p_m_brief': s_p_m_brief
			}
		}
		return true
	return
