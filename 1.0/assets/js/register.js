// Generated by CoffeeScript 1.6.3
$(document).ready(function() {
  $("#l_submit").click(function() {
    $.ajax({
      url: '/register',
      success: function(result) {
        console.log(result);
      },
      async: true,
      type: 'POST',
      data: {
        'r_u_party_name': 'chuangwang',
        'r_u_email': '592030542@qq.com',
        'r_u_pwd': md5('123')
      }
    });
    return true;
  });
});
