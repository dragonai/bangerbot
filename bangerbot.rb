require 'sinatra'
require 'redditkit'

get '/' do
	client = RedditKit::Client.new('x', 'x')
	top_bangers = client.search('site:soundcloud.com', {
		:subreddit => 'trap',
		:time => 'month',
		:sort => 'top',
		:restrict_to_subreddit => true,
		:limit => 50
		})

	top_bangers.results.map { |banger| banger.url }.sample
end
