#!/usr/bin/env ruby

=begin
 Author: Corey Weiner
 Date:   3/27/2012
 Purpose: A gem file that helps to integrate tweeting and scores updates using yahoo_sports gem
=end
 

# files required to use this gem
require 'twitter'
require 'net/http'
require 'yahoo_sports'
require 'oauth'
require 'json'
require 'launchy'


module SportFu
	
	VERSION = '0.0.1'
	
	class TwitFu
		
		attr :consumer, :request_token, :pin, :access_token, :redirect_to, :response, :token_hash
		
		# Initialize the class with a user name and password for the twitter account
		def initialize(consumer_key, consumer_secret)
				@consumer = OAuth::Consumer.new consumer_key, consumer_secret,
																				{ :site => 'http://twitter.com/',
																					:request_token_path => '/oauth/request_token',
																					:access_token_path => '/oauth/access_token',
																					:authorize_path => '/oauth/authorize',
																					:scheme => :header										
																				}
		end
		
		# Requires the user to authenticate the app. if they have never
		# done this before it directs them to the twitter site where they
		# are presented with a pin that they enter and it writes the
		# authentication tokens to a file where they are read back in as
		# not to generate a new pin each call.
		def grantAccess()
			if File.zero?('lib/data.txt') #if files doesn't exist it then gets the access_tokens
				@request_token = @consumer.get_request_token
				Launchy.open("#{@request_token.authorize_url}")
				puts "Enter pin that the page gave you: #{@pin}" 
				@pin = STDIN.readline.chomp
				@access_token = @request_token.get_access_token(:oauth_verifier => @pin)
				puts @access_token.token
				File.open('lib/data.txt','w') do |f|
					f.puts @access_token.token
					f.puts @access_token.secret
				end
			else #if they exist it simple reads them into token_hash
				File.open('lib/data.txt','r') do |f|
					@token_hash = { :oauth_token => f.readline.chomp,
											    :oauth_token_secret => f.readline.chomp
										 		}
					end
			end
		end
		
	end # Class Client End
end # Module SportFu end

key = "8gHeFgeBBx4UsLHoF15Y4A"
secret = "t3tMQZZ4bq4jgwdaC1HD5A5pi2HdRN34nicVyN1xo"
app = SportFu::TwitFu.new(key,secret)
app.grantAccess
#puts "Enter a tweet: "
#tweet = STDIN.readline.chomp
#app.postUpdate(tweet)