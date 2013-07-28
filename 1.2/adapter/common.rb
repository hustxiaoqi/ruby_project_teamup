#coding: UTF-8

exit unless Object.const_defined? :ACCESS_ERROR

require 'sinatra'
require 'digest'

set :public_folder, "#{MAIN_PATH}assets" 

set :session_secret, ENV["SESSION_KEY"] || Digest::MD5.hexdigest(ENV['ASH_MONGODB_PASSWORD'])
enable :sessions

before do
	session[:ash_uid] ||= 0
end
