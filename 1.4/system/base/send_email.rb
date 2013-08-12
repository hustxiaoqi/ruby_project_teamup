#coding: UTF-8

exit unless Object.const_defined? :ACCESS_ERROR

require 'pp'
require 'net/smtp'

module Ash
	module Utils

		class SendEmail

			@@email_from = Ash::Disposition::COMMON_EMAIL_FROM_EMAIL
			@@email_pwd = Ash::Disposition::COMMON_EMAIL_FROM_PASSWORD
			@@email_port = Ash::Disposition::COMMON_EMAIL_PORT
			@@email_server = Ash::Disposition::COMMON_EMAIL_SERVER

			def initialize(to_user)
				@email_to = to_user
			end

			public
			def send_verify_html(message)
				begin
					email_message = <<MESSAGE_END
From: Tower Maker <chuangwangtower@163.com>
To: Tower Register User <#{@email_to}>
MIME-Version: 1.0
Content-type: text/html
Subject: Complete your HustUnique tower registration with one click!

<h2>Hi #{message[:party_name]} <#{@email_to}></h2>
<div><p>Thanks for signing up, we just need to verify your email address:</p>
<p><a style="font-size:14px;font-weight:bold;color:white;border:1px solid #0d851b;background:#15981e;text-decoration:none;padding:5px 10px" href="#{message[:user_href]}">Verify your email address</a></p>
</div>
<div>
<p>Sincerely,</p>
</p>The hust_unique tower Team</p>
</div>
MESSAGE_END
					puts email_message
					smtp = Net::SMTP.start(@@email_server, @@email_port, @@email_from, @@email_from, @@email_pwd, :login)

					smtp.send_message email_message, @@email_from, @email_to
					smtp.finish
					true
				rescue
					puts $!
					false
				end
			end

			def send_onverify_success_html
				begin
					email_message = <<MESSAGE_END
From: Tower Maker <chuangwangtower@163.com>
To: Tower Register User <#{@email_to}>
MIME-Version: 1.0
Content-type: text/html
Subject: Welcome to HustUnique Tower

<h2>Welcome TO HustUnique Tower </h2>
<div>
<a style="font-size:14px;font-weight:bold;color:white;border:1px solid #0d851b;background:#15981e;text-decoration:none;padding:5px 10px" href="http://127.0.01:4567/">Start HustUnique Tower</a>
</div>
<div>
<p>Sincerely,</p>
</p>The hust_unique tower Team</p>
</div>
MESSAGE_END
					smtp = Net::SMTP.start(@@email_server, @@email_port, @@email_from, @@email_from, @@email_pwd, :login)

					smtp.send_message email_message, @@email_from, @email_to
					smtp.finish
					true
				rescue
					puts $!
					false
				end
			end

			def send(message)
				begin
					email_message = <<MESSAGE_END
From: Tower Maker <chuangwangtower@163.com>
To: Tower Register User <#{@email_to}>
MIME-Version: 1.0
Content-type: text/html
Subject: Complete your HustUnique tower registration with one click!

<h2>Hi #{message[:party_name]} <#{@email_to}></h2>
<div><p>Thanks for signing up, we just need to verify your email address:</p>
<p><a style="font-size:14px;font-weight:bold;color:white;border:1px solid #0d851b;background:#15981e;text-decoration:none;padding:5px 10px" href="#{message[:user_href]}">Verify your email address</a></p>
</div>
<div>
<p>Sincerely,</p>
</p>The hust_unique tower Team</p>
</div>
MESSAGE_END
					smtp = Net::SMTP.start(@@email_server, @@email_port, @@email_from, @@email_from, @@email_pwd, :login)

					smtp.send_message email_message, @@email_from, @email_to
					smtp.finish
					true
				rescue
					puts $!
					false
				end
			end
			#def send
				#begin
					#from = 'chuangwangtower@163.com'
					#to = '592030542@qq.com'
					#message = <<MESSAGE_END
#From: Tower Maker <chuangwangtower@163.com>
#To: Register User <#{to}>
#MIME-Version: 1.0
#Content-type: text/html
#Subject: Welcome to HustUnique Tower

#<h2>Welcome TO HustUnique Tower </h2>
#<div>
#<a style="font-size:14px;font-weight:bold;color:white;border:1px solid #0d851b;background:#15981e;text-decoration:none;padding:5px 10px" href="http://127.0.01:4567/">Start HustUnique Tower</a>
#</div>
#<div>
#<p>Sincerely,</p>
#</p>The hust_unique tower Team</p>
#</div>
#MESSAGE_END
					#puts message
					#smtp = Net::SMTP.start('smtp.163.com', 25, from, from, 'hustunique_tower', :login)

					#smtp.send_message message, from, to
					#smtp.finish
					##smtp = Net::SMTP.start('smtp.163.com', 25, 'chuangwangtower@163.com', 'chuangwangtower@163.com', 'hustunique_tower', :login)
					##smtp.send_message(@email_message, 'chuangwangtower@163.com', '592030542@qq.com')
					##smtp.finish
					#true
				#rescue
					#puts $!
					#false
				#end
				##begin
					##@email_smtp.send_message(@email_message, @email_from, @email_to)
					##flag = true
				##rescue
					##puts $!
					##flag = false
				##ensure
					##@email_smtp.finish
				##end
				##flag
			#end
		end
	end
end
