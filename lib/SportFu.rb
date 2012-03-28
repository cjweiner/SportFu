#!/usr/bin/env ruby

=begin
 Author: Corey Weiner
 Date:   3/27/2012
 Purpose: A gem file that helps to integrate tweeting and scores updates using yahoo_sports gem
=end
 

# files required to use this gem
require 'net/http'
require 'yahoo_sports'
require 'oauth'
require 'json'
require 'launchy'



class SportFu
	
	attr :onsumer, :request_token, :pin, :accessToken, :redirect_to
	
	auth = {}
	
	# Initialize the class with a user name and password for the twitter account
	def initialize(key, secret)
			@consumer = OAuth::Consumer.new key,
																			secret,
																			{ :site => 'http://twitter.com/',
																				:request_token_path => '/oauth/request_token',
																				:access_token_path => '/oauth/access_token',
																				:authorize_path => '/oauth/authorize'}
	end
	
	# Reuires the user to authenticate and allow access to the app.
	# Using launchy it launches a default web browser that will then
	# prompt the user to log in.
	def grantAccess()
		@request_token = @consumer.get_request_token
		Launchy.open("#{@request_token.authorize_url}")
		
	end
	
end

key = "8gHeFgeBBx4UsLHoF15Y4A"
secret = "t3tMQZZ4bq4jgwdaC1HD5A5pi2HdRN34nicVyN1xo"
app = SportFu.new(key,secret)
app.grantAccess