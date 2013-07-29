#coding: UTF-8

require 'sinatra'

get '/settings/person' do
	redirect to('/login') if session[:ash_uid] == 0
	pp session
  Ash::UtilsModules.load_module_files 'settings', 'person'
	Ash::UtilsModules.display_module_outline(request.dup)
	Ash::ModuleApp::PersonSettingsView.new.default(request.xhr?)
end

post '/settings/person' do
	redirect to('/login') if session[:ash_uid] == 0
	pp session
  Ash::UtilsModules.load_module_files 'settings', 'person'
	Ash::UtilsModules.display_module_outline(request.dup)
	Ash::ModuleApp::PersonSettingsView.new.default(request.xhr?)
end
