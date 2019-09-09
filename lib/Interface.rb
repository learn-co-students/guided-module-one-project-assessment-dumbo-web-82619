class Interface
    attr_reader :prompt
    attr_accessor :user, :gym, :program, :registration

    def initialize()
        @prompt = TTY::Prompt.new
    end

    def welcome
        system "clear"
        puts "Welcome to GymFinder!"
        choice = self.prompt.select("Are you a New user or Returning user?") do |menu|
            menu.choice "New User"
            menu.choice "Returning User"
        end
        case choice
        when "New User"
            User.handle_new_user
        when "Returning User"
            User.handle_returning_user
        end 
    end

    def main_menu
        system "clear"
        choice = self.prompt.select("Welcome! Please select one of the following:") do |menu|
            menu.choice "My Gyms", -> {self.gym_menu}
            menu.choice "Browse Gyms and Programs"
            menu.choice "Exit"
        end
    end
        # case choice
    #     when "My Gyms"
    #         gyms = self.user.registrations.map do |registration|
    #             Gym.find(registration.gym_id)
    #         end
    #         system "clear"
    #         selection = nil
    #         option = self.prompt.select("Here are your registered gyms:") do |menu|
    #             gyms.map do |gym|
    #             selection = gym.name
    #             menu.choice "#{selection}"
    #             end
    #         end
    #         case option
    #         when selection
    #             programs = Gym.find_by(name: selection).programs
    #             binding.pry
    #             puts programs
    #         end
    #         # binding.pry
            
    #         # puts gym_names
    #         sleep 3
    #         self.main_menu
    #     end
    # end

    def gym_menu
        gyms = self.user.registrations.map do |registration|
            Gym.find(registration.gym_id)
        end
        system "clear"
        option = self.prompt.select("Here are your registered gyms:") do |menu|
            gyms.map do |gym|
            menu.choice "#{gym.name}", -> {Gym.find_by(name: gym.name).list_gym_programs}
            end
        end
    end

    

end