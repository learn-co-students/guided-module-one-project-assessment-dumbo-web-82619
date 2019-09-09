class User < ActiveRecord::Base
    has_many :registrations
    has_many :gyms, through: :registrations
    
    def programs
        self.gyms.map do |gym|
            gym.programs
        end
    end


end