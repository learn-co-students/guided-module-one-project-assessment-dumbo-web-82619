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

    def self.handle_new_user
        name = self.tty_prompt.ask("What is your name? (Please enter your full name)")
        age = self.tty_prompt.ask("What is your age? (Please enter your age as an integer)")
        city = self.tty_prompt.ask("What city do you reside in?")
        state = self.tty_prompt.ask("What state do you reside in?")
        User.create(name: name.titleize, age: age, city: city.titleize, state: state.titleize)
    end

    def self.handle_returning_user
        name = self.tty_prompt.ask("Please enter your full name")
        city = self.tty_prompt.ask("Please enter your city")
        state = self.tty_prompt.ask("Please enter your state")
        User.find_by(name: name.titleize, city: city.titleize, state: state.titleize)
    end


end