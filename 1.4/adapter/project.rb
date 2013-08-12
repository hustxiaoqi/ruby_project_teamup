#coding: UTF-8

require 'sinatra'

get '/team/:project/' do

	status, headers, body = call env.merge("PATH_INFO" => "/team/#{params[:project]}")
	[status, headers, body]
end

get '/team/:project' do
	redirect to('/login') if session[:ash_uid] == 0
	redirect to('/login') unless session[:ash_tuuid] == params[:project]
	pp session
  Ash::UtilsModules.load_module_files 'project'
	Ash::UtilsModules.display_module_outline request.dup
	Ash::ModuleApp::ProjectView.new.default(session[:ash_uid], session[:ash_ttid], session[:ash_tuuid], session[:ash_tauth])
end

get '/team/:project/newproject' do
	redirect to('/login') if session[:ash_uid] == 0
	redirect to('/login') unless session[:ash_tuuid] == params[:project]
	pp session
  Ash::UtilsModules.load_module_files 'project'
	Ash::UtilsModules.display_module_outline request.dup
	if request.xhr?
		Ash::ModuleApp::CViewProject.new.view_ajax_newproject(session[:ash_uid], session[:ash_ttid], session[:ash_tuuid], session[:ash_tauth])
	else
		Ash::ModuleApp::CViewProject.new.view_newproject(session[:ash_uid], session[:ash_ttid], session[:ash_tuuid], session[:ash_tauth])
	end
end

post '/team/:project/newproject' do
	redirect to('/login') if session[:ash_uid] == 0
	redirect to('/login') unless session[:ash_tuuid] == params[:project]
	pp session
  Ash::UtilsModules.load_module_files 'project'
	Ash::UtilsModules.display_module_outline request.dup, 'view_verify_newproject', params.dup
	Ash::ModuleApp::CViewProject.new.view_verify_newproject(session[:ash_uid], session[:ash_ttid], session[:ash_tuuid], session[:ash_tauth], params['p_n_name'], params['p_n_content'])

end
