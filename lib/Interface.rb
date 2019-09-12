class Interface
    attr_reader :prompt
    attr_accessor :user, :gym, :program, :registration

    def initialize()
        @prompt = TTY::Prompt.new
    end

    def welcome
        system "clear"
        puts "Welcome to GymFinder!"
        puts ""
        choice = self.prompt.select("Are you a New user or Returning user?") do |menu|
            menu.choice "New User", ->{User.handle_new_user}
            menu.choice "Returning User", -> {User.handle_returning_user}
        end
    end

    def main_menu
        system "clear"
        puts "Hello, #{self.user.name}!"
        puts ""
        choice = self.prompt.select("Welcome! Please select one of the following:") do |menu|
            menu.choice "My Gyms", -> {self.user.gym_menu}
            menu.choice "Manage Memberships", -> {self.user.manage_memberships}
            menu.choice "Manage Account", -> {self.user.manage_account}
            menu.choice "Search Gyms", -> {self.search}
            menu.choice "Exit", -> {Interface.exit_app}
        end
    end

    def search
        system "clear"
        self.prompt.select("Select a search-by option?") do |menu|
            menu.choice "Search by name", -> {Gym.prompt_name}
            menu.choice "Search by program", ->{Program.finder}
            menu.choice "Search by location", ->{Gym.finder}
            menu.choice "Main Menu"
        end
    end
    
    def self.exit_app
        system "clear"
        puts ""
        puts "See you next time!"
        puts ""
        exit!
    end

end