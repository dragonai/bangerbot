require 'sinatra'
require 'redditkit'
require 'rufus-scheduler'

top_bangers = []

scheduler = Rufus::Scheduler.new

scheduler.every '10d', :first_in => '0.1s' do
	client = RedditKit::Client.new(ENV['REDDIT_USERNAME'], ENV['REDDIT_PASSWORD'])
	top_bangers = client.search('site:soundcloud.com', {
		:subreddit => 'trap',
		:time => 'month',
		:sort => 'top',
		:restrict_to_subreddit => true,
		:limit => 50
		}).results
end

get '/' do
	random_banger = top_bangers.sample

	content_type :json
	{
		:response_type => "in_channel",
		:text => random_banger.url,
		:attachments => [
			{
				:fallback => random_banger.media[:oembed][:title],
				:color => '#ff5500',
				:title => random_banger.media[:oembed][:title],
				:title_link => random_banger.url,
				:text => random_banger.media[:oembed][:description],
				:thumb_url => random_banger.media[:oembed][:thumbnail_url]
	        }
		]
	}.to_json
end
