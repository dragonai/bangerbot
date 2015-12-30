require 'sinatra'
require 'redditkit'
require 'rufus-scheduler'

banger_array = []

scheduler = Rufus::Scheduler.new

scheduler.every '10d', :first_in => '0.1s' do
	client = RedditKit::Client.new(ENV['REDDIT_USERNAME'], ENV['REDDIT_PASSWORD'])
	top_bangers = client.search('site:soundcloud.com', {
		:subreddit => 'trap',
		:time => 'month',
		:sort => 'top',
		:restrict_to_subreddit => true,
		:limit => 50
		})
	banger_array = top_bangers.results.map { |banger| banger.url.sub('https://', 'http://') }

end

get '/' do
	content_type :json
	{ :response_type => "in_channel", :text => banger_array.sample, :unfurl_media => true }.to_json
end
