#coding: UTF-8

require 'sinatra'

get '/settings/person' do
	redirect to('/login') if session[:ash_uid] == 0
	pp session
  Ash::UtilsModules.load_module_files 'settings', 'person'
	Ash::UtilsModules.display_module_outline(request.dup)
	Ash::ModuleApp::PersonSettingsView.new.default(session[:ash_uid], session[:ash_uemail], request.xhr?)
end

post '/settings/person' do
	redirect to('/login') if session[:ash_uid] == 0
	pp session
  Ash::UtilsModules.load_module_files 'settings', 'person'
	Ash::UtilsModules.display_module_outline(request.dup, 'view_verify_psetting', params.dup)
	Ash::ModuleApp::PersonSettingsView.new.view_verify_psetting(session[:ash_uid], params['s_p_m_name'], params['s_p_m_brief'])
end

post '/settings/person/photo' do
	redirect to('/login') if session[:ash_uid] == 0
	pp session
  Ash::UtilsModules.load_module_files 'settings', 'person'
	Ash::UtilsModules.display_module_outline(request.dup, 'view_verify_ps_photo', params.dup)
	Ash::ModuleApp::PersonSettingsView.new.view_verify_ps_photo(session[:ash_uid], params['s_p_m_photo'])
end
