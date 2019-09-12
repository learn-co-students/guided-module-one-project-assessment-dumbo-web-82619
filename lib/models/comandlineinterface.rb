class ComandLineInterface 

    attr_accessor :prompt, :user
def initialize()
    @prompt = TTY::Prompt.new
end

def greet
    system "clear"
    puts"**********************Welcome to  C.F.A************************"
 
    # choice = self.prompt.select("Are you a ...") do |m|
    #     m.choice "CONTRACTOR"
    #     m.choice "FREELANCER"
    # end
    # case choice
    # when "CONTRACTOR"
       puts "Welcome Contractor"
       choice = self.prompt.select("Are you a ....") do |m|
        m.choice "new user",->{Contractor.new_contractor}
        m.choice "Existing_user",->{Contractor.verify_contractor}
       end
       @user = choice
       while @user ==nil
        system "clear"
                puts "
                
                
                
                
                
                
                
                
                *****👀👀👀[CONTRACTOR NOT FOUND]👀👀👀*****
                "

            sleep 3
            greet
       end
       cont_menu(@user) 
    # when "FREELANCER"
    #     puts "Welcome Freelancer"
    #     choice = self.prompt.select("Are you a ....") do |m| 
    #      m.choice "new user",->{Freelancer.new_freelancer}
    #      m.choice "Existing_user",->{Freelancer.verify_freelancer}
    #     end
    #     @user = choice
    #     fl_menu 
    # end


end

 def cont_menu(user_instance)
    system "clear"
    choice = prompt.select("What would you like to do today") do |m|
        m.choice "view freelancer",->{user_instance.my_freelancers(self)}
        m.choice "View contracts",->{user_instance.my_contracts(self)}
        m.choice "[LOG_OUT]",->{}
   end
   
end


# def fl_menu
#     system "clear"
#     choice = self.prompt.select("What would you like to do today") do |m|
#         m.choice "Update your bio ?",->{user_instance.update_bio(self)}
#         m.choice "View your contracts ?",->{self.user.my_contracts(self) }
#         m.choice "[LOG_OUT]",->{}
#    end
# end





end