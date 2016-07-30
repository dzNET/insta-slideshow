require 'sinatra'
require 'haml'
require 'open-uri'
require 'json'

get '/' do
  haml :index
end

get '/slideshow' do
  haml :error
end

post '/slideshow' do

  if page = params[:page].to_i > 10
    page = "10"
  else
    page = params[:page].to_i
  end

  tag = params[:tag]
  data = []

  def all_data(ithem, data)
    ithem.each do |ithem|
      info_url = "https://www.instagram.com/p/#{ ithem["code"] }/?__a=1"
      info = JSON.parse(open( info_url ).read)
      data.push(ithem.to_a + info.to_a)
    end
    return data
  end

  tag_url = "https://www.instagram.com/explore/tags/#{ tag }/?__a=1"
  res = JSON.parse(open( tag_url ).read)["tag"]["media"]
  page_info = res["page_info"]
  content = res["nodes"]

  all_data(content, data)

  page.times do
    if page_info["has_next_page"]
      params = "&max_id=" + page_info["end_cursor"]
      res = JSON.parse(open( tag_url + params ).read)["tag"]["media"]

      page_info = res["page_info"]
      content = res["nodes"]

      all_data(content, data)
    end
  end

  haml :slideshow, :locals => {:tag => tag, :page => page, :data => data}
end