#coding: UTF-8

require 'sinatra'

get '/team' do
	redirect to('/login') if session[:ash_uid] == 0
	pp session
  Ash::UtilsModules.load_module_files 'team'
	Ash::UtilsModules.display_module_outline request.dup, 'view_ready_teams', params
	tv_info = Ash::ModuleApp::TeamView.new.view_ready_teams(session)

	if tv_info == true
		redirect to("/team/#{session[:ash_tuuid]}")
	else
		tv_info
	end
end
