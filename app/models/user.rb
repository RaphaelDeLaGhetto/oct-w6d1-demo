class User < ActiveRecord::Base
   has_many :caches 
end