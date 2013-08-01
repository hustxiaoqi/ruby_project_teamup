#coding: UTF-8

require 'sinatra'

get '/settings/person' do
	redirect to('/login') unless checked?
  Ash::UtilsModules.load_module_files 'settings', 'person'
	Ash::UtilsModules.display_module_outline(request.dup)
	Ash::ModuleApp::PersonSettingsView.new.default(session[:ash_uid], session[:ash_uemail], request.xhr?)
end

post '/settings/person' do
	redirect to('/login') unless checked?
  Ash::UtilsModules.load_module_files 'settings', 'person'
	Ash::UtilsModules.display_module_outline(request.dup, 'view_verify_psetting', params.dup)
	Ash::ModuleApp::PersonSettingsView.new.view_verify_psetting(session[:ash_uid], params['s_p_m_name'], params['s_p_m_brief'])
end

post '/settings/person/photo' do
	redirect to('/login') unless checked?
  Ash::UtilsModules.load_module_files 'settings', 'person'
	Ash::UtilsModules.display_module_outline(request.dup, 'view_verify_ps_photo', params.dup)
	Ash::ModuleApp::PersonSettingsView.new.view_verify_ps_photo(session[:ash_uid], params['s_p_m_photo'])
end

get '/settings/person/password' do
	redirect to('/login') unless checked?
  Ash::UtilsModules.load_module_files 'settings', 'person'
	Ash::UtilsModules.display_module_outline(request.dup, 'view_alter_password')
	Ash::ModuleApp::PersonSettingsView.new.view_alter_password(request.xhr?)
end

post '/settings/person/password' do
	redirect to('/login') unless checked?
  Ash::UtilsModules.load_module_files 'settings', 'person'
	Ash::UtilsModules.display_module_outline(request.dup, 'view_verify_altpwd', params.dup)
	Ash::ModuleApp::PersonSettingsView.new.view_verify_altpwd(session[:ash_uid], params['s_p_m_opwd'], params['s_p_m_npwd'])
end


#========> team setting
get '/settings/team/:teamid/' do
	status, headers, body = call env.merge("PATH_INFO" => "/settings/team/#{params[:teamid]}")
	[status, headers, body]
end

get '/settings/team/:teamid' do
	pp session
	redirect to('/login') unless checked?(true)
  Ash::UtilsModules.load_module_files 'settings', 'team'
	Ash::UtilsModules.display_module_outline(request.dup)
	Ash::ModuleApp::TeamSettingsView.new.default(session[:ash_ttid], session[:ash_tauth], request.xhr?)
end

