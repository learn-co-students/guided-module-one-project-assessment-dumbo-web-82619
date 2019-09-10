class User < ActiveRecord::Base
    has_many :registrations
    has_many :gyms, through: :registrations

    def self.tty_prompt
        TTY::Prompt.new
    end
    
    def programs
        self.gyms.map do |gym|
            gym.programs
        end
    end

    def active_memberships
        self.registrations.select do |registration|
            registration.status == "Active"
        end
    end

    def inactive_memberships
        self.registrations.select do |registration|
            registration.status == "Inactive"
        end
    end

    def nearby_gyms
        Gym.all.select do |gym|
            gym.city == self.city
        end
    end

    def register_gym(gym, date)
        
        Registration.create(user_id: self.id, gym_id: gym.id, start_date: date, status: "Active")
    end

    def suspend_membership(gym)
        membership = self.registrations.find_by(gym_id: gym.id)
        membership.update_attribute(:status, "Inactive")
        membership.save
    end

    def reactivate_membership(gym)
        membership = self.registrations.find_by(gym_id: gym.id)
        membership.update_attribute(:status, "Active")
        membership.save
    end

    def cancel_membership(gym)
        membership = self.registrations.find_by(gym_id: gym.id)
        membership.destroy
    end

    # def find_gym_by_program(program_arg)
    #     gym_program = []
    #     Gym.all.each do |gym|
    #         selected = gym.programs.where("name like ?", "%#{program_arg}%") || gym.programs.where("category like ?", "%#{program_arg}%") || gym.programs.where("description like ?", "%#{program_arg}%")
        
    #          binding.pry
    #         if selected.size > 0
    #             gym_program << selected
    #         end
    #     end
    #     binding.pry
    #     gym_program
    #     Program.where("name like ?", "%#{program_arg}%") || program.where("category like ?", "%#{program_arg}%") || program.where("description like ?", "%#{program_arg}%")
    # end

    #Creates a new user --->
    def self.handle_new_user
        name = self.tty_prompt.ask("What is your name? (Please enter your full name)")
        age = self.tty_prompt.ask("What is your age? (Please enter your age as an integer)")
        city = self.tty_prompt.ask("What city do you reside in?")
        state = self.tty_prompt.ask("What state do you reside in?")
        User.create(name: name.titleize, age: age, city: city.titleize, state: state.titleize)
    end

    #Finds a select user --->
    def self.handle_returning_user
        name = self.tty_prompt.ask("Please enter your full name")
        city = self.tty_prompt.ask("Please enter your city")
        state = self.tty_prompt.ask("Please enter your state")
        User.find_by(name: name.titleize, city: city.titleize, state: state.titleize)
    end

    def manage_memberships
        puts "Here are your current memberships: \n"
        active = self.active_memberships.map do |membership|
            "ID##{membership.gym_id}) #{Gym.find(membership.gym_id).name}:
            start date: #{membership.start_date}, status: #{membership.status} \n"
        end
        inactive = self.inactive_memberships.map do |membership|
            "ID##{membership.gym_id}) #{Gym.find(membership.gym_id).name}:
            start date: #{membership.start_date}, status: #{membership.status} \n"
        end
        puts active
        puts inactive
        choice = TTY::Prompt.new.select("What action would you like to perform?") do |menu|
            menu.choice "Update Status", -> {self.membership_update}
            menu.choice "Register New Membership", -> {self.gym_register}
            menu.choice "Cancel Membership", -> {self.membership_cancel}
            menu.choice "Exit"
        end
    end

    def gym_memberships
        memberships = self.registrations.each do |registration|
            registration[:name] = Gym.find(registration.gym_id).name
        end
        memberships
    end

    def membership_update
        gym = TTY::Prompt.new.ask("Please enter the ID of the gym membership you wish to update:")
        found = Registration.find_by(gym_id: gym, user_id: self.id)
        if found == nil
            system "clear"
            puts "Sorry, that membership does not exist"
            sleep 2
            self.membership_update
        else
            if found.status == "Active"
                self.suspend_membership(Gym.find(found.gym_id))
                system "clear"
                puts "Your membership has been suspended"
                sleep 2
                self.manage_memberships
            else
                self.reactivate_membership(Gym.find(found.gym_id))
                system "clear"
                puts "Your membership has been reactivated"
                sleep 2
                self.manage_memberships
            end
        end
    end

    def membership_cancel
        gym = TTY::Prompt.new.ask("Please enter the ID of the gym membership you wish to update:")
        found = Registration.find_by(gym_id: gym, user_id: self.id)
        if found == nil
            system "clear"
            puts "Sorry, that membership does not exist"
            sleep 2
            self.membership_update
        else
            self.cancel_membership(Gym.find(found.gym_id))
            puts "Your membership has been canceled"
            sleep 2
            self.membership_update
        end
    end

    def gym_register
        TTY::Prompt.new.select("Select a gym to register:") do |menu|
            Gym.all.map do |gym|
                menu.choice "#{gym.name}", -> {self.register_action(gym)}
            end
        end
    end

    def register_action(gym)
        date = TTY::Prompt.new.ask("Please enter your desired start date? (ie. January 1, 2019)")
        self.register_gym(gym, date)
        puts "Your selected gym's membership has been confirmed"
        sleep 2
        self.manage_memberships
    end


end