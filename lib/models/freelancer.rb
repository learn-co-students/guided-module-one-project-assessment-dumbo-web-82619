class Freelancer < ActiveRecord::Base
    attr_accessor :prompt
    has_many :contracts
    has_many :contractors, through: :contracts

   

    def self.tty_prompt
        prompt = TTY::Prompt.new
    end

    def tty_prompt
        prompt = TTY::Prompt.new
    end

    # def self.new_freelancer
    #     name = self.tty_prompt.ask("what is your name?")
    #     age= self.tty_prompt.ask("what is your age?")
    #     dob = self.tty_prompt.ask("what is your Date of Birth?")
    #     certifications = self.tty_prompt.ask("List your certifications:")
    #       Freelancer.create(name: name, age: age, dob: dob, bio: bio, certifications: certifications)
    # end
        
    # def self.verify_freelancer
    #         name = self.tty_prompt.ask("Verify your name?")
    #         Freelancer.find_by(name: name)
    # end 

    # def update_bio(cli_instance)
    #     name = tty_prompt.ask("what would you like to change your name to..")
    #     age = tty_prompt.ask("what is your age ?")
    #     dob = tty_prompt.ask("what is your DateOfBirth")
    #     certifications = tty_prompt.ask("List your certifications:")
    #     Freelancer.all.find(cli_instance).update(name: name, age: age, dob: dob, certifications:certifications)
    # end


end