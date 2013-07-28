#coding: UTF-8

exit unless Object.const_defined? :ACCESS_ERROR

require 'sinatra'

before do
	session[:ash_uid] ||= 0
end
