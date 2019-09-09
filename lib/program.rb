class Program < ActiveRecord::Base
    belongs_to :gym
    
    def users
        self.gym.users
    end




end