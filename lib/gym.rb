class Gym < ActiveRecord::Base
    has_many :registrations
    has_many :users, through: :registrations
    has_many :programs


end