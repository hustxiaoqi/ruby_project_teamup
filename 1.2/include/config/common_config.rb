#coding: UTF-8

exit unless Object.const_defined? :ACCESS_ERROR

module Ash
	module Disposition

		# website uri
		COMMON_BASE_URI = 'http://localhost:8080/'

		# 2 (minus)(600(s))
		COMMON_TOKEN_EXPIRES = 60 * 2

		# active user
		COMMON_ACTIVE = 2 ** 7
		COMMON_NOT_ACTIVE = 2 ** 6

		# forzen user/team/project
		COMMON_FROZEN = 2 ** 9
		COMMON_NOT_FROZEN = 2 ** 8

		# reset password time(2 day)
		COMMON_RESET_PWD_TIME = 2 * 24 * 60 * 60

		# being used
		COMMON_BEING_USED = 2 * 5
		COMMON_NOT_BEING_USED = 2 * 4

		# email configuration
		COMMON_EMAIL_SERVER = 'smtp.163.com'
		COMMON_EMAIL_PORT = 25
		COMMON_EMAIL_FROM_EMAIL = 'chuangwangtower@163.com'
		COMMON_EMAIL_FROM_PASSWORD = 'hustunique_tower'

		# bae email configuration
		COMMON_BAE_EMAIL_URI = "http://ashsendemail.duapp.com/"
		COMMON_BAE_EMAIL_TOKEN = "chuangwang_ruby_project_2013_teamup"

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

		#page return error info
		COMMON_PAGE_ERROR_UNABLE = 20
		COMMON_PAGE_ERROR_UNABLE_INFO = "Unable Error"
		COMMON_PAGE_SUCCESS = 100
		COMMON_PAGE_SUCCESS_INFO = "Success"
		COMMON_PAGE_EQUAL = 50

		#member config info
		COMMON_MEMBER_NAME_MAX_ZH_LENGTH = 10
		COMMON_MEMBER_NAME_MAX_US_LENGTH = 30
		COMMON_MEMBER_BRIEFS_MAX_ZH_LENGTH = 30
		COMMON_MEMBER_BRIEFS_MAX_US_LENGTH = 90
		COMMON_MEMBER_BRIEFS_DEFAULT_INFO = "---"
		COMMON_MEMBER_PHOTO_DEFAULT_FILE = '7.png'

		#other
		#picture
		COMMON_USING_IMAGE_TYPES = ["JPEG", "PNG"]
		COMMON_USING_IMAGE_WIDTH = 100
		COMMON_USING_IMAGE_HEIGHT = 100

	end
end
