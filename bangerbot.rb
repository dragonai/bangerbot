require 'sinatra'
require 'redditkit'
require 'rufus-scheduler'

banger_array = []

scheduler = Rufus::Scheduler.new

scheduler.every '10d', :first_in => '0.1s' do
	client = RedditKit::Client.new('x', 'x')
	top_bangers = client.search('site:soundcloud.com', {
		:subreddit => 'trap',
		:time => 'month',
		:sort => 'top',
		:restrict_to_subreddit => true,
		:limit => 50
		})
	banger_array = top_bangers.results.map { |banger| banger.url }
end

get '/' do
	banger_array.sample
end
