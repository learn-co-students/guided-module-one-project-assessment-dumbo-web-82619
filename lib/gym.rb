class Gym < ActiveRecord::Base
    has_many :registrations
    has_many :users, through: :registrations
    has_many :programs

    def self.programs
        self.all.map do |gym|
            gym.programs
        end
    end

    #-----------------List programs after a gym has been selected --->
    
    def list_gym_programs
        system "clear"
        program = TTY::Prompt.new.select("Gym Program(s):", self.programs.pluck(:name))
        found = (Program.find_by(name: program)).description
        puts found
        puts ""
        TTY::Prompt.new.select(" ") do |menu|
            menu.choice "Back to programs", -> {self.list_gym_programs}
            menu.choice "Main Menu"
        end
    end


#--------query select: search by name------------------------------------------->

    def self.prompt_name
        system "clear"
        gym_name = TTY::Prompt.new.ask("Enter the name of the gym:")
        puts ""
        found = self.find_gym_by_name(gym_name)
        found.each do |f|
            puts "#{f.name}: #{f.city}, #{f.state}"
        end
        TTY::Prompt.new.select(" ") do |menu|
            menu.choice "Main Menu"
        end
    end

    def self.find_gym_by_name(name_arg)
        selected = self.where("name like ?", "%#{name_arg}%")
    end


#----------------------query parameter------------------------>

    def self.finder 
        system "clear"
        puts "Search for gym by location"
        puts ""
        TTY::Prompt.new.select("Select query option:") do |menu|
            menu.choice "Find by city", -> {self.city_finder}
            menu.choice "Find by state", -> {self.state_finder}
            menu.choice "Main Menu"
        end
    end


#----------------query select: search by city------------------>

    def self.city_finder
        cities = self.all.map do |gym|
            gym.city
        end
        TTY::Prompt.new.select("Gyms by city:") do |menu|
            cities.uniq.each do |city|
                menu.choice "#{city}", -> {self.find_gym_by_city(city)}
            end
            menu.choice "Back", -> {self.finder}
        end
    end

    def self.find_gym_by_city(city)
        arr = self.all.select do |gym|
            gym.city == city
        end
        system "clear"
        arr.map do |gym|
            puts gym.name
        end
        TTY::Prompt.new.select(" ") do |menu|
            menu.choice "Back", -> {self.city_finder}
            menu.choice "Main Menu"
        end
    end

#------------------query select: search by state--------------------->

    def self.state_finder
        states = self.all.map do |gym|
            gym.state
        end
        TTY::Prompt.new.select("Gyms by state:") do |menu|
            states.uniq.each do |state|
                menu.choice "#{state}", -> {self.find_gym_by_state(state)}
            end
            menu.choice "Back", -> {self.finder}
        end
    end
    
    def self.find_gym_by_state(state)
        arr = self.all.select do |gym|
            gym.state == state
        end
        system "clear"
        arr.map do |gym|
            puts gym.name
        end
        TTY::Prompt.new.select(" ") do |menu|
            menu.choice "Back", -> {self.state_finder}
            menu.choice "Main Menu"
        end
    end

end