#coding: UTF-8

exit unless Object.const_defined? :ACCESS_ERROR

module Ash
	module Disposition

		# 2 (minus)(600(s))
		COMMON_TOKEN_EXPIRES = 60 * 2

		# active user
		COMMON_ACTIVE = 128

		# email configuration
		COMMON_EMAIL_SERVER = 'smtp.163.com'
		COMMON_EMAIL_PORT = 25
		COMMON_EMAIL_FROM_EMAIL = 'chuangwangtower@163.com'
		COMMON_EMAIL_FROM_PASSWORD = 'hustunique_tower'
		# 2(day)
		COMMON_EMAIL_TOKEN_EXPIRES = 2 * 24 * 60 * 60
		#COMMON_EMAIL_TOKEN_EXPIRES = 10

		# Authority
		#team
		COMMON_TEAM_CREATE_AUTHORITY = 2 ** 12
		COMMON_TEAM_MANAGE_AUTHORITY = 2 ** 10
		COMMON_TEAM_PARTICIPATE_AUTHORITY = 2 ** 10

		#project
		COMMON_PROJECT_CREATE_AUTHORITY = 2 ** 17
		COMMON_PROJECT_MANAGE_AUTHORITY = 2 ** 16
		COMMON_PROJECT_PARTICIPATE_AUTHORITY = 2 ** 15

	end
end
