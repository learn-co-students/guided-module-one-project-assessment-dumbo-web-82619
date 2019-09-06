class User < ActiveRecord::Base
    has_many :registrations
    has_many :gyms, through: :registrations
    


end