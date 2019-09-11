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

    #-------------USER HANDLES-------------------------------------------------------------------->

    def self.handle_new_user
        name = self.tty_prompt.ask("What is your name? (Please enter your full name)")
        age = self.tty_prompt.ask("What is your age? (Please enter your age as an integer)")
        city = self.tty_prompt.ask("What city do you reside in?")
        state = self.tty_prompt.ask("What state do you reside in?")
        user = User.create(name: name.titleize, age: age, city: city.titleize, state: state.titleize)
    end

    def self.handle_returning_user
        name = self.tty_prompt.ask("Please enter your full name")
        city = self.tty_prompt.ask("Please enter your city")
        state = self.tty_prompt.ask("Please enter your state")
        user = User.find_by(name: name.titleize, city: city.titleize, state: state.titleize)
    end

    
    #-----------------------------Gym Menu from "My Gym" after a user is selected--->
    
    def gym_menu
        if self.gyms == []
            # binding.pry
            puts "You are not registered to any gyms at the moment"
            sleep 3
        else
            gyms = self.registrations.map do |registration|
                Gym.find(registration.gym_id)
            end
            system "clear"
                TTY::Prompt.new.select("Here are your registered gyms:") do |menu|
                gyms.map do |gym|
                menu.choice "#{gym.name}", -> {Gym.find_by(name: gym.name).list_gym_programs}
                end
            end
        end
    end
 
 
 #-----------membership management page------------------------------------->

    def manage_memberships
        system "clear"
        if self.gyms == []
            puts "You have no memberships to show"
            puts ""
            TTY::Prompt.new.select("Would you like to register for a membership?") do |menu|
                menu.choice "Yes", -> {self.gym_register}
                menu.choice "No"
            end
        else
            active = self.active_memberships.map do |membership|
                "ID# #{membership.gym_id}) #{Gym.find(membership.gym_id).name}:
                start date: #{membership.start_date}, status: #{membership.status}\n"
            end
            inactive = self.inactive_memberships.map do |membership|
                "ID# #{membership.gym_id}) #{Gym.find(membership.gym_id).name}:
                start date: #{membership.start_date}, status: #{membership.status}\n"
            end
            # system "clear"
            puts "Here are your current memberships:"
            puts ""
            puts active
            puts ""
            puts inactive
            puts ""
            TTY::Prompt.new.select("What action would you like to perform?") do |menu|
                menu.choice "Update Status", -> {self.membership_update}
                menu.choice "Register New Membership", -> {self.gym_register}
                menu.choice "Cancel Membership", -> {self.membership_cancel}
                menu.choice "Exit"
            end
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


 #-----------change membership status----------------------------------->
   
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

 
#--------create new gym membership------------------------------>

    def gym_register
        TTY::Prompt.new.select("Select a gym to register:") do |menu|
            Gym.all.map do |gym|
                menu.choice "#{gym.name}", -> {self.register_action(gym)}
            end
        end
    end

    def register_action(gym)
        if self.gyms.include?(gym)
            puts "You are already registered to that gym"
            sleep 2
            self.manage_memberships
        else
            date = TTY::Prompt.new.ask("Please enter your desired start date? (ie. January 1, 2019)")
            self.register_gym(gym, date)
            puts "Your selected gym's membership has been confirmed"
            sleep 2
            self.manage_memberships
        end
    end


#---------destroy registration object(membership)------------------->

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
            system "clear"
            puts "Your membership has been canceled"
            TTY::Prompt.new.select(" ") do |menu|
                menu.choice "Back to programs", -> {self.manage_memberships}
                menu.choice "Back to Menu"
            end
        end
    end

    def cancel_membership(gym)
        membership = self.registrations.find_by(gym_id: gym.id)
        membership.destroy
    end


#-------------miscellaneous---------------------------------------->


    def nearby_gyms
        Gym.all.select do |gym|
            gym.city == self.city
        end
    end

    def register_gym(gym, date) 
        Registration.create(user_id: self.id, gym_id: gym.id, start_date: date, status: "Active")
    end

    def gym_memberships
        memberships = self.registrations.each do |registration|
            registration[:name] = Gym.find(registration.gym_id).name
        end
        memberships
    end

    
end