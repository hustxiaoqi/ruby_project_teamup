#coding: UTF-8

exit unless Object.const_defined? :ACCESS_ERROR

require 'sinatra'
require 'digest'

set :public_folder, "#{MAIN_PATH}assets" 

set :session_secret, ENV["SESSION_KEY"] || Digest::MD5.hexdigest(ENV['ASH_MONGODB_PASSWORD'])
enable :sessions

before do
	unless session[:ash_uid].nil?
		session[:ash_uid] = 0 unless Ash::ExtraDB::MemberHelper.new.member?(session[:ash_uid])
		if Object.const_defined? :ASH_STRICT_MODE
			unless session[:ash_ttid].nil? and session[:ash_tuuid].nil?
				session[:ash_uid] = 0 unless Ash::ExtraDB::TeamHelper.new.team?(session[:ash_ttid], session[:ash_tuuid])
			end
		end
	else
		session[:ash_uid] = 0
	end
end
