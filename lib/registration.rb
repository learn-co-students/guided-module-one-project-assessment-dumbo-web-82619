class Registration < ActiveRecord::Base
    belongs_to :user
    belongs_to :gym

    def programs
        self.gym.programs
    end

end