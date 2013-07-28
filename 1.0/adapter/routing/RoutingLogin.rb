#coding: UTF-8

require 'sinatra'

get '/login' do
	#redirect to('/login') if session[:ash_uid] == 0
	#Ash::Utils.set_module_gvar 'home'
	session.clear
	session[:ash_uid] = 0
  Ash::UtilsModules.load_module_files 'login'
	Ash::UtilsModules.display_module_outline(request.dup)
	Ash::ModuleApp::CViewLogin.new.default
end

post '/login' do
	#redirect to('/login') if session[:ash_uid] == 0
	#Ash::Utils.set_module_gvar 'home'
	session.clear
	session[:ash_uid] = 0
  Ash::UtilsModules.load_module_files 'login'
	Ash::UtilsModules.display_module_outline request.dup, 'view_verify_login', params
	Ash::ModuleApp::CViewLogin.new.view_verify_login(params['l_u_email'], params['l_u_pwd'], params['l_u_token'], session)
end

get '/login/randomImage' do
	session.clear
	session[:ash_uid] = 0
  Ash::UtilsModules.load_module_files 'login'
	Ash::UtilsModules.display_module_outline request.dup, 'view_random_image', params
	Ash::ModuleApp::CViewLogin.new.view_random_image(params['l_r_email'], params['l_r_time'])
end
