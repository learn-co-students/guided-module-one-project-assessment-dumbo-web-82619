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
        system "clear"
        puts "Please enter your account information"
        puts ""
        name = self.tty_prompt.ask("What is your name? (Please enter your full name)")
        system "clear"
        puts "Please enter your account information"
        puts ""
        age = self.tty_prompt.ask("What is your age? (Please enter your age as an integer)")
        system "clear"
        puts "Please enter your account information"
        puts ""
        city = self.tty_prompt.ask("What city do you reside in?")
        system "clear"
        puts "Please enter your account information"
        puts ""
        state = self.tty_prompt.ask("What state do you reside in?")
        system "clear"
        puts "Please enter your account information"
        puts ""
        username = self.tty_prompt.ask("Create a username")
        until !self.usernames.include?(username)
            system "clear"
            puts "That username already exists."
            puts ""
            username = self.tty_prompt.ask("Please try a different username.")
        end
        system "clear"
        puts "Please enter your account information"
        puts ""
        password = self.tty_prompt.mask("Create a password")
        password_confirm = self.tty_prompt.mask("Confirm password")
        until password == password_confirm
            system "clear"
            puts "Invalid entry. Please try again."
            puts ""
            password = self.tty_prompt.mask("Create a password")
            password_confirm = self.tty_prompt.mask("Confirm password")
        end
        system "clear"
        puts "Here's your new account information:"
        puts ""
        puts "Username: #{username}"
        puts "Name: #{name.titleize}"
        puts "Age: #{age}"
        puts "City: #{city.titleize}"
        puts "State: #{state.titleize}"
        puts ""
        TTY::Prompt.new.select("Is your account information correct?") do |menu|
            menu.choice "Yes", -> {User.create(username: username, password: password, name: name.titleize, age: age, city: city.titleize, state: state.titleize)}
            menu.choice "No", -> {self.handle_new_user}
        end
    end

    def self.handle_returning_user
        system "clear"
        username = self.tty_prompt.ask("Enter your username")
        password = self.tty_prompt.mask("Enter your password")
        if self.usernames.include?(username)
            if self.passwords.include?(password)
                user = User.find_by(username: username, password: password)
            else
                TTY::Prompt.new.select("Invalid password") do |menu|
                        menu.choice "Try again?", -> {self.handle_returning_user}
                        menu.choice "Exit App", -> {Interface.exit_app}
                    end
        #Produces and indefinite loop when password is repeatedly incorrect:∆
                # until User.find_by(username: username, password: password)
                #     system "clear"
                #     puts "Incorrect password. Please re-enter."
                #     sleep 1
                #     system "clear"
                #     password = self.tty_prompt.mask("Enter your password")
                # end
                # user = User.find_by(username: username, password: password)
            end
        else
            puts "Sorry, we do not have that username on file."
            sleep 1
            self.handle_returning_user
        end
    end
    

#---------------------------usernames & passwords--------------------------->

    def self.usernames
        self.all.map do |user|
            user.username
        end
    end

    def self.passwords
        self.all.map do |user|
            user.password
        end
    end

    
    #-----------------------------Gym Menu from "My Gym" after a user is selected--->
    
    def gym_menu
        if self.gyms == []
            system "clear"
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
                menu.choice "Main Menu"
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
            puts ""
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
                menu.choice "Main Menu"
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
            self.manage_memberships
        #    this prompt is unecessary. recursion returns you to mem manager, can exit from there
        #     TTY::Prompt.new.select(" ") do |menu|
        #         menu.choice "Back to programs", -> {self.manage_memberships}
        #         menu.choice "Main Menu"
        #    end
        end
    end

    def cancel_membership(gym)
        membership = self.registrations.find_by(gym_id: gym.id)
        membership.destroy
    end

#------------------Manage Account-------------------------------->

    def manage_account
        system "clear"
        puts "Here's your account information:"
        puts ""
        puts "Username: #{self.username}"
        puts "Name: #{self.name}"
        puts "Age: #{self.age}"
        puts "City: #{self.city}"
        puts "State: #{self.state}"
        puts ""
        TTY::Prompt.new.select("Account Options", per_page: 7) do |menu|
            menu.choice "Change Username", -> {self.change_username_prompt}
            menu.choice "Change Password", -> {self.change_password_prompt}
            menu.choice "Edit Name", -> {self.change_name_prompt}
            menu.choice "Edit City", -> {self.change_city_prompt}
            menu.choice "Edit State", -> {self.change_state_prompt}
            menu.choice "Delete Account", -> {self.delete_account_prompt}
            menu.choice "Main Menu"
        end
    end


#---------------------------Edit User Attributes------------------------------->

    def change_username_prompt
        system "clear"
        TTY::Prompt.new.select("Are you sure you want to change your username?") do |menu|
            menu.choice "Yes", -> {self.change_username}
            menu.choice "No", -> {self.manage_account}
        end
    end

    def change_username
        puts "Your current username is: #{self.username}"
        puts ""
        username = TTY::Prompt.new.ask("What is your new username?")
        until !User.usernames.include?(username)
            system "clear"
            puts "That username already exists."
            puts ""
            username = User.tty_prompt.ask("Please try a different username.")
        end
        self.update_attribute(:username, username)
        self.save
        system "clear"
        puts "Your username has been updated"
        sleep 2
        self.manage_account
    end

    def change_password_prompt
        system "clear"
        TTY::Prompt.new.select("Are you sure you want to edit your password?") do |menu|
            menu.choice "Yes", -> {self.change_password}
            menu.choice "No", -> {self.manage_account}
        end
    end

    def change_password
        puts "Your current password is: #{self.password}"
        puts ""
        password = TTY::Prompt.new.mask("What is your new password?")
        password_confirm = TTY::Prompt.new.mask("Confirm password")
        until password == password_confirm
            system "clear"
            puts "Invalid entry. Please try again."
            puts ""
            password = TTY::Prompt.new.mask("What is your new password?")
            password_confirm = TTY::Prompt.new.mask("Confirm password")
        end
        self.update_attribute(:password, password)
        self.save
        system "clear"
        puts "Your password has been updated"
        sleep 2
        self.manage_account
    end

    def change_name_prompt
        system "clear"
        TTY::Prompt.new.select("Are you sure you want to edit name?") do |menu|
            menu.choice "Yes", -> {self.change_name}
            menu.choice "No", -> {self.manage_account}
        end
    end

    def change_name
        system "clear"
        puts "Your current name is: #{self.name.titleize}"
        puts ""
        name = TTY::Prompt.new.ask("What is your new name? (Please enter your full name)")
        self.update_attribute(:name, name)
        self.save
        system "clear"
        puts "Your name has been updated"
        sleep 2
        self.manage_account
    end

    def change_city_prompt
        system "clear"
        TTY::Prompt.new.select("Are you sure you want to edit city?") do |menu|
            menu.choice "Yes", -> {self.change_city}
            menu.choice "No", -> {self.manage_account}
        end
    end

    def change_city
        puts "You currently live in: #{self.city}"
        puts ""
        city = TTY::Prompt.new.ask("What is your new city?")
        self.update_attribute(:city, city.titleize)
        self.save
        system "clear"
        puts "Your city has been updated"
        sleep 2
        self.manage_account
    end

    def change_state_prompt
        system "clear"
        TTY::Prompt.new.select("Are you sure you want to edit state?") do |menu|
            menu.choice "Yes", -> {self.change_state}
            menu.choice "No", -> {self.manage_account}
        end
    end

    def change_state
        puts "Your current state is: #{self.state}"
        puts ""
        state = TTY::Prompt.new.ask("What is your new state?")
        self.update_attribute(:state, state.titleize)
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