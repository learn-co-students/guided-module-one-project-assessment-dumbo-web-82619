class Gym < ActiveRecord::Base
    has_many :registrations
    has_many :users, through: :registrations
    has_many :programs

    def self.programs
        self.all.map do |gym|
            gym.programs
        end
    end

    def self.find_gym_by_name(name_arg)
        selected = self.where("name like ?", "%#{name_arg}%")
    end

    def list_gym_programs
        system "clear"
        program = TTY::Prompt.new.select("Gym Programs:", self.programs.pluck(:name))
        found = Program.find_by(name: program)
        system "clear"
        puts found.name
        puts found.description
    end


    def self.find_gym_by_state(state)
        self.all.select do |gym|
            gym.state == state
        end
    end

    def self.find_gym_by_city(city)
        self.all.select do |gym|
            gym.city == city
        end
    end

end