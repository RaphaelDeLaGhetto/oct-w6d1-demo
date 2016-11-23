
get '/' do
  @caches = Cache.all
  erb :index
end