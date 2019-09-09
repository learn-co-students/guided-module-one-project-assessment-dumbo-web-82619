class Contract < ActiveRecord::Base
  belongs_to :contractor
  belongs_to :freelancer
  
end
