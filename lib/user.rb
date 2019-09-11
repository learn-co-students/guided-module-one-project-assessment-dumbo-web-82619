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
        active = self.active_memberships.map do |membership|
            "ID# #{membership.gym_id}) #{Gym.find(membership.gym_id).name}:
            start date: #{membership.start_date}, status: #{membership.status}\n"
        end
        inactive = self.inactive_memberships.map do |membership|
            "ID# #{membership.gym_id}) #{Gym.find(membership.gym_id).name}:
            start date: #{membership.start_date}, status: #{membership.status}\n"
        end
        system "clear"
        if self.gyms == []
            system "clear"
            puts "You have no memberships to show"
            puts ""
            TTY::Prompt.new.select("Would you like to register for a membership?") do |menu|
                menu.choice "Yes", -> {self.gym_register}
                menu.choice "No"
            end
        else
            system "clear"
            puts "Here are your current memberships:"
            puts "Active:"
            puts active
            puts ""
            puts "Inactive:"
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
                q = self.suspend_membership(Gym.find(found.gym_id))
                system "clear"
                puts "Your membership has been suspended"
                self.reload
                sleep 2
                self.manage_memberships
            else
                self.reactivate_membership(Gym.find(found.gym_id))
                system "clear"
                puts "Your membership has been reactivated"
                self.reload
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
            system "clear"
            puts "Your selected gym's membership has been confirmed"
            self.reload
            sleep 2
            self.manage_memberships
        end
    end

    def register_gym(gym, date) 
        Registration.create(user_id: self.id, gym_id: gym.id, start_date: date, status: "Active")
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
            self.reload
            sleep 2
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

#------------------Manage Account-------------------------------->

    def manage_account
        TTY::Prompt.new.select("Account Options") do |menu|
            menu.choice "Edit Name", -> {self.change_name}
            menu.choice "Edit City", -> {self.change_city}
            menu.choice "Edit State", -> {self.change_state}
            menu.choice "Delete Account", -> {self.delete_account_prompt}
            menu.choice "Exit"
        end
    end


#---------------------------Edit User Attributes------------------------------->

    def change_name
        puts "Your current name is: #{self.name}"
        puts ""
        name = TTY::Prompt.new.ask("What is your new name? (Please enter your full name)")
        self.update_attribute(:name, name)
        self.save
        system "clear"
        puts "Your name has been updated"
        sleep 2
        self.manage_account
    end

    def change_city
        puts "You currently live in: #{self.city}"
        puts ""
        city = TTY::Prompt.new.ask("What is your new city?")
        self.update_attribute(:city, city)
        self.save
        system "clear"
        puts "Your city has been updated"
        sleep 2
        self.manage_account
    end

    def change_state
        puts "Your current state is: #{self.state}"
        puts ""
        state = TTY::Prompt.new.ask("What is your new state?")
        self.update_attribute(:state, state)
        self.save
        system "clear"
        puts "Your state has been updated"
        sleep 2
        self.manage_account
    end

#---------------------------------Delete User Account----------------->

    def delete_account_prompt
        TTY::Prompt.new.select("Are you sure you would like to delete your account?") do |menu|
            menu.choice "Yes", -> {self.delete_account}
            menu.choice "No", -> {self.manage_account}
        end
    end

    def delete_account
        self.destroy
        system "clear"
        puts "Your account has been deleted"
        sleep 2
        puts "Thank you for using GymFinder"
        sleep 2
        puts "Sorry our services could not satisfy you"
        system "clear"
        sleep 2
        exit!
    end


#-------------miscellaneous---------------------------------------->


    def nearby_gyms
        Gym.all.select do |gym|
            gym.city == self.city
        end
    end

    def gym_memberships
        memberships = self.registrations.each do |registration|
            registration[:name] = Gym.find(registration.gym_id).name
        end
        memberships
    end

    
end