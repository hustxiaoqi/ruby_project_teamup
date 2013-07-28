#coding: UTF-8

ACCESS_ERROR ||= true
ASH_DEBUG ||= true

MAIN_PATH = File.expand_path('../../') + '/'

require "#{MAIN_PATH}plugin/project/ProjectView.rb"
require 'test/unit'

class TestTeamContorl < Test::Unit::TestCase
	def test_default_ok
		session = {"ash_uid"=>"51f037d1efd71728eb000001", "ash_uname"=>"", "ash_uemail"=>"592030542@qq.com", "ash_uact"=>0, "ash_ustartt"=>"1374835964", "session_id"=>"cf047e4ee8f62aa5e1f59d6c74116e8420c0241a7879d6c645a7aa247479e21a", "tracking"=>{"HTTP_USER_AGENT"=>"aa01876b35ad2033c18761a31062f9f7e9965c8c", "HTTP_ACCEPT_ENCODING"=>"ed2b3ca90a4e723402367a1d17c8b28392842398", "HTTP_ACCEPT_LANGUAGE"=>"a9d5b5e00249c1b72f2ea374194e8f83f9c5188a"}, "ash_ttid"=>"51f29a93f02736ae24f38bc1", "ash_tauth"=>4096, "ash_tuuid"=>"2d9191b3771073c914e4eeb97def216d2e5e626d"}
		puts Ash::ModuleApp::CViewProject.new.default(session['ash_uid'], session['ash_ttid'], session['ash_tuuid'], session['ash_tauth'])
	end
end
