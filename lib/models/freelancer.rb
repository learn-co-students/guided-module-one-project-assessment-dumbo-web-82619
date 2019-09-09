class Freelancer < ActiveRecord::Base
    has_many :contracts
    has_many :contractors, through: :contracts
end