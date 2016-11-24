class Cache < ActiveRecord::Base
   belongs_to :user
   
   validates_presence_of :coordinates, message: "not recorded in image"
   validates :description, presence: true
   validates :image, presence: true
    
   def days_ago
     (Time.now.to_date - self.created_at.to_date).to_i  
   end
   
   def get_freshness
     days = self.days_ago    
     if days < 3
       "Fresh find"
     elsif days >= 3 && days < 7
       "Getting stale"
     else
       "Probably long gone"
     end
   end
end