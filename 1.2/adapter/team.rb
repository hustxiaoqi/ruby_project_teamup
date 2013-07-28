#coding: UTF-8

require 'sinatra'
require 'pp'

get '/team' do
	redirect to('/login') if session[:ash_uid] == 0
	pp session
  Ash::UtilsModules.load_module_files 'team'
	Ash::UtilsModules.display_module_outline request.dup, 'view_ready_teams', params
	Ash::ModuleApp::TeamView.new.view_ready_teams(session)

	redirect to("/team/#{session[:ash_tuuid]}")
end
