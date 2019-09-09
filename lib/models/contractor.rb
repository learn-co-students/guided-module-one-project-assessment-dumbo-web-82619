class Contractor < ActiveRecord::Base
    has_many :contracts
    has_many :freelancers, through: :contracts
end