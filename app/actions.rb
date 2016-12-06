helpers do
  def logged_in?
    !session[:user_id].nil?
  end
end


#['/new', '/users', '/users/:id', /edit/].each do |path|
['/new', '/users'].each do |path|
  before path do
    redirect('/login') if !logged_in? 
  end
end

before  do
  if request.path !~ /login/ &&
     request.request_method == "POST" ||
     request.request_method == "PUT" ||
     request.request_method == "DELETE"
    @ip = request.ip
    halt(401, erb(:error_401)) unless logged_in? 
  end
end


get '/' do
  @caches = Cache.order(created_at: :desc)
  erb :index
end

get '/new' do
  @cache = Cache.new
  erb :new
end

post '/cache' do
  @cache = Cache.new
  
  # Set description
  @cache.description = params[:description]
    
  # Move file into storage
  tempfile = params[:image][:tempfile] 
  filename = params[:image][:filename] 
  filepath = "uploads/#{filename}"
  @cache.image = filepath
  filepath = "public/#{filepath}"
  FileUtils.cp(tempfile.path, filepath)
  
  # Calculate coords from EXIF rational numbers
  # 2016-11-23 http://stackoverflow.com/questions/18244721/mapping-exif-data-to-long-lat
  if EXIFR::JPEG.new(filepath).exif?
    latitude = EXIFR::JPEG.new(filepath).gps_latitude[0].to_f +
               EXIFR::JPEG.new(filepath).gps_latitude[1].to_f / 60 +
               EXIFR::JPEG.new(filepath).gps_latitude[2].to_f / 3600
    latitude *= -1 if EXIFR::JPEG.new(filepath).gps_latitude_ref == 'S'
    longitude = EXIFR::JPEG.new(filepath).gps_longitude[0].to_f +
                EXIFR::JPEG.new(filepath).gps_longitude[1].to_f / 60 +
                EXIFR::JPEG.new(filepath).gps_longitude[2].to_f / 3600 
    longitude *= -1 if EXIFR::JPEG.new(filepath).gps_longitude_ref == 'W'
    coords = "#{latitude},#{longitude}"
    
    @cache.coordinates = coords
  end
    
  if @cache.save
    redirect '/'
  else
    erb :new
  end
end


get '/login' do
  @user = User.new
  erb :login
end

post '/login' do
  @user = User.find_by_email(params[:email])  
#  if !@user 
#    @user = User.new
#  end
    
  if @user.password == params[:password]
    session[:user_id] = @user.id
    redirect '/'
  else
    erb :login
  end
end

get '/logout' do
  session.clear
  redirect '/'
end

#
# RESTful user API
#

# Shows all the users in the database
get '/users/?' do
  @users = User.all
  erb(:'users/index')
end

# Get form for creating a new user
get '/users/new' do
  @user = User.new
  erb(:'users/new')
end

# Actually create a new user
post '/users' do
  @user = User.new(params)
  if @user.save
    redirect('/users')
  else
    erb(:'users/new')
  end
end

# Show me one user
get '/users/:id' do
  @user = User.find(params[:id])
  erb(:'users/show')
end

# Edit a user
get '/users/:id/edit' do
  @user = User.find(params[:id])
  erb(:'users/edit')
end 

# Update user
put '/users/:id' do
  @user = User.find(params[:id])
  if @user.update(params[:user])
    redirect("users/#{@user.id}")
  else
    erb(:'users/edit')
  end
end

# Delete user
delete '/users/:id' do
  User.delete(params[:id])
  redirect('/users')
end

