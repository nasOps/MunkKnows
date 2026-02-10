# Main application file - Routes + Controllers (combined)

require 'sinatra'
require 'sinatra/activerecord'
require 'json'
require_relative 'config/environment'
require_relative 'models/page'

class WhoknowsApp < Sinatra::Base
  register Sinatra::ActiveRecordExtension


  get "/" do
    "Sinatra says Hello World!"
  end

  get '/api/search' do
    content_type :json

    q = params[:q]
    language = params[:language] || 'en'

    if q.nil? || q.empty?
      search_results = []
    else
      search_results = Page.where(language: language)
                           .where("content LIKE ?", "%#{q}%")
                           .as_json
    end

    { search_results: search_results }.to_json
  end

  run! if app_file == $0
end