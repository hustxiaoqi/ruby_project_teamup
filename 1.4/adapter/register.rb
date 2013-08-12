#coding: UTF-8

require 'sinatra'

get '/register' do
	#redirect to('/') if session[:ash_uid] != 0
	session.clear
	session[:ash_uid] = 0
  Ash::UtilsModules.load_module_files 'register'
	Ash::UtilsModules.display_module_outline(request.dup)
	Ash::ModuleApp::RegisterView.new.default
end

post '/register' do
	#redirect to('/') if session[:ash_uid] != 0
	session.clear
	session[:ash_uid] = 0
  Ash::UtilsModules.load_module_files 'register'
	Ash::UtilsModules.display_module_outline request.dup, 'view_verify_register', params
	Ash::ModuleApp::RegisterView.new.view_verify_register(params['r_u_party_name'], params['r_u_email'], params['r_u_pwd'])
end

get '/register/onverify' do
  Ash::UtilsModules.load_module_files 'register'
	Ash::UtilsModules.display_module_outline request.dup, 'view_onverify_register', params
	Ash::ModuleApp::RegisterView.new.view_onverify_register(params['r_u_email'], params['r_u_token'], params['r_u_type'])
end
