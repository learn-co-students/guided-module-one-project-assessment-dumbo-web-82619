class Program < ActiveRecord::Base
    belongs_to :gym
    
    def users
        self.gym.users
    end

    def registrations
        self.gym.registrations
    end


#-----------query parameter------------------------------------------>

    def self.finder 
        system "clear"
        TTY::Prompt.new.select("Select query option:") do |menu|
            menu.choice "Find by name", -> {self.name_finder}
            menu.choice "Find by category", -> {self.category_finder}
            menu.choice "Main Menu"
        end
    end


#-----------query select: search by name--------------------------------->

    def self.name_finder
        system "clear"
        names = Program.all.map do |program|
            program.name
        end
        TTY::Prompt.new.select("Programs by name:") do |menu|
            names.uniq.each do |name|
                menu.choice "#{name}", -> {self.find_gym_by_name(name)}
            end
            menu.choice "Back", -> {self.finder}
        end
    end

    def self.find_gym_by_name(name_arg)
        p = self.all.select do |program|
            program.name == name_arg
        end
        gym = p.map do |program|
            Gym.find(program.gym_id)
        end
        system "clear"
        gym.map do |g|
            puts g.name
        end
        TTY::Prompt.new.select(" ") do |menu|
            menu.choice "Back", -> {self.name_finder}
            menu.choice "Main Menu"
        end
    end


#-----------query select: search by category--------------------------->

    def self.category_finder
        system "clear"
        categories = Program.all.map do |program|
                program.category
            end
        TTY::Prompt.new.select("Programs by category:") do |menu|
            categories.uniq.each do |category|
                menu.choice "#{category}", -> {self.find_gym_by_category(category)}
            end
            menu.choice "Back", -> {self.finder}
        end
    end
    
    def self.find_gym_by_category(category_arg)
        p = self.all.select do |program|
            program.category == category_arg
        end
        a = p.map do |program|
            Gym.find(program.gym_id)
        end
        system "clear"
        a.map do |it|
            puts it.name
        end
        TTY::Prompt.new.select(" ") do |menu|
            menu.choice "Back", -> {self.category_finder}
            menu.choice "Main Menu"
        end
    end

end