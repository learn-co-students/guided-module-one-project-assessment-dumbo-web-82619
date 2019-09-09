class Program < ActiveRecord::Base
    belongs_to :gym
    
    def users
        self.gym.users
    end

    def registrations
        self.gym.registrations
    end

    def self.find_gym_by_category(category_arg)
        p = self.all.select do |program|
            program.category == category_arg
        end
        p.map do |program|
            Gym.find(program.gym_id)
        end
    end

    def self.find_gym_by_name(name_arg)
        p = self.all.select do |program|
            program.name == name_arg
        end
        p.map do |program|
            Gym.find(program.gym_id)
        end
    end

end