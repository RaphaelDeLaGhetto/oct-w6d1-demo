helpers do
  def logged_in?
    !session[:user_id].nil?
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