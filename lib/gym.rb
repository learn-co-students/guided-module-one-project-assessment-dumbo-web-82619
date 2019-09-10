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

    def self.prompt_name
        gym_name = TTY::Prompt.new.ask("Enter the name of the gym:")
        found = self.find_gym_by_name(gym_name)
    
        puts "#{found[0].name}: #{found[0].city}, #{found[0].state}"
        TTY::Prompt.new.select(" ") do |menu|
            menu.choice "Back to Menu"
        end
    end


    #List programs after a gym has been selected --->
    def list_gym_programs
        system "clear"
        program = TTY::Prompt.new.select("Gym Program[s]:", self.programs.pluck(:name))
        found = (Program.find_by(name: program)).description
        # binding.pry
        puts found
        # sleep 5
        TTY::Prompt.new.select(" ") do |menu|
            menu.choice "Back to programs", -> {self.list_gym_programs}
            menu.choice "Back to Menu"
        end

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