class Contractor < ActiveRecord::Base
    has_many :contracts
    has_many :freelancers, through: :contracts

    def self.tty_prompt
        prompt = TTY::Prompt.new(symbols: {tick: '√'})
    end

    def tty_prompt
        prompt = TTY::Prompt.new(symbols: {tick: '√'})
    end


    def self.new_contractor
        name = self.tty_prompt.ask("what is your name?")
        company_name = self.tty_prompt.ask("what is your company name?")
        feilds = self.tty_prompt.ask("what feilds do you operate in?")
        bio = self.tty_prompt.ask("Give us a brief description of company bio:")
          Contractor.create(name: name, company_name: company_name, feilds: feilds, bio: bio)
    end
        
    def self.verify_contractor
            name = self.tty_prompt.ask("what is your name?")
            yes = Contractor.all.find_by(name: name)
    end 
           
    
    def new_freelancer(user_instance)
        system "clear"
        name = tty_prompt.ask("what is there name?")
        age = tty_prompt.ask("what is there age?")
        
        dob = tty_prompt.ask("what is there date of birth?")
        certifications = tty_prompt.ask("Any particular feild cerification? ")
            Freelancer.create(name: name, age: age, dob: dob, certifications: certifications)  
            system "clear"
            puts "*****Freelancer_added*****" 
            sleep 3
            finder(user_instance)
        end

        def freelance_name
        Freelancer.all.map{|n| n.name}
    end

    def my_freelancers(user_instance) 
        system "clear"
        fr_option = tty_prompt.select("Would you lke to do ...") do |m|
            m.choice "Select a existing FREELANCER"
            m.choice "Make new 'FREELANCER'",->{new_freelancer(user_instance)}
        end
        case fr_option
        when "Select a existing FREELANCER"
            system "clear"
        fl_name = tty_prompt.select( "What freelancer would you like to view", freelance_name )
            choice = tty_prompt.select("What would you like to do with #{fl_name} ?") do |m|
                m.choice "Update Freelancer",->{fl_update(fl_name, user_instance)}
                m.choice "Remove Freelancer",->{remove_freelance(fl_name, user_instance)}
                m.choice "View Freelancer",->{view_freelancer(fl_name, user_instance)}
                m.choice "back to menu"
            end 
            case choice
            when "back to menu"
                finder(user_instance)
            end
        end 
    end
    
    def view_freelancer(fl_name,user_instance)
        obj = Freelancer.all.find_by(name: fl_name)
        puts "#{obj.name}"
        puts "#{obj.age}"
        puts "#{obj.dob}"
        puts "#{obj.certifications}"

         sleep 3
         finder(user_instance)
         
         # name_inst = Freelancer.all.select{|m| m.name == fl_name}
    end

    def fl_update(fl_name,user_instance)
        puts "Updating #{fl_name}"
        name = tty_prompt.ask("NEW name:")
        age = tty_prompt.ask("NEW age:")
        dob = tty_prompt.ask("NEW dob:")
        certifications = tty_prompt.ask("NEW certifications:")
        Freelancer.all.find_by(name: fl_name).update(name: name, age: age, dob: dob, certifications: certifications)
        system 'clear'
        puts "
        
                              *****📞📞📞📞📞LANCER HAS BEEN UPDATED📞📞📞📞📞*****
                              
                                                
                              
                                                
                              "
        sleep 3
        finder(user_instance)
    end
    
    def remove_freelance(fl_name,user_instance)
        system "clear"
        tty_prompt.select("THIS WILL PERMANENTLY DELETE FREELANCER") do |m| 
        m.choice "yes",-> {Freelancer.all.find_by(name: fl_name).delete}
        m.choice "no",->{user_instance.cont_menu}
        end
        system "clear"
        puts "
        
        
        
        
        
                            *****🗑🗑🗑🗑🗑🗑🗑[LANCER HAS BEEN REMOVED]🗑🗑🗑🗑🗑🗑🗑*****
                                                                            
                                                                            
                            
                                                                            
                                                                            
                                                                            
                            
        "
        sleep 3
        finder(user_instance)
    end 
    
    def contract_name
        Contract.all.map{|c|c.description}
    end

    
    
    def my_contracts(user_instance)
        system "clear"
        cont_option = tty_prompt.select("Would you lke to...") do |m|
            m.choice "  🗃 🗃 🗃 🗃 Select a existing CONTRACT  🗃 🗃 🗃 🗃  "
            m.choice "     📝  📝  📝   [Make new 'CONTRACT]    📝  📝  📝     ",->{new_contract(user_instance)}
            m.choice "        🛰🛰🛰       [FREELANCERS]       🛰🛰🛰          ",->{my_freelancers(user_instance)}
            m.choice "                         [EXIT]                            ",->{  ComandLineInterface.exit_cont_menu}
        end
        case cont_option
        when "  🗃 🗃 🗃 🗃 Select a existing CONTRACT  🗃 🗃 🗃 🗃  "
            system "clear"
            cont_name = tty_prompt.select( "What CONTRACT would you like to view", contract_name )
            choice = tty_prompt.select("What would you like to do with #{cont_name} ?") do |m|
                m.choice "UPDATE CONTRACT",->{cont_update(cont_name, user_instance)}
                m.choice "DELETE CONTRACT",->{remove_cont(cont_name, user_instance)}
                m.choice "back to menu"
            end
            case choice
            when "back to menu"
                
            end  
        end
        finder(user_instance)
    end
    
    def new_contract(user_instance)

        system "clear"
            description = tty_prompt.ask("description:")
            pay_out = tty_prompt.ask("PayOut")
            start_date = tty_prompt.ask("StartDate")
            choice = tty_prompt.select("Choose Freelancer", Freelancer.all.map{|person| person.name}) 
            freelancer_id = Freelancer.all.find_by(name: choice)
            Contract.create(contractor_id: user_instance, freelancer_id: freelancer_id.id, description: description, pay_out: pay_out, start_date: start_date )
            system "clear"
            puts "
            
            
            
            
               x***** 📄 📄 📄 📄 📄 👀👀👀👀👀👀 [CONTRACT CREATED] 📄 📄 📄 📄 📄 👀👀👀👀👀👀 *****
            
            
            
            
            "
            sleep 3
            finder(user_instance)
    end

    def finder(user_instance)
        my_contracts(user_instance)
    end


    def cont_update(cont_name, user_instance)
        system "clear"
        puts "TYPE.."
        # cont_description = tty_prompt.select("Which CONTRACT", Contract.all.map{|c| c.description})
        description = tty_prompt.ask("NEW description:")
        freelance_ = tty_prompt.select("Choose Freelancer", Freelancer.all.map{|person| person.name}) 
        freelancer_id = Freelancer.all.find_by(name: freelance_)
        pay_out = tty_prompt.ask("NEW pay_out:")
        start_date = tty_prompt.ask("NEW start_date:")
        Contract.all.find_by(description: cont_name).update(description: description, freelancer_id: freelancer_id.id, pay_out: pay_out, start_date: start_date)
        system "clear"
        puts "
        
        
        
                             *****✒️✒️✒️✒️✒️  [CONTRACT HAS BEEN UPDATED]  🖋🖋🖋🖋🖋*****
        
        
        
        "
        sleep 3
        finder(user_instance)
    end
    
    def remove_cont(cont_name,user_instance)
        system "clear"
        tty_prompt.select("THIS WILL PERMANENTLY DELETE CONTRACT") do |m| 
            m.choice "yes",-> {Contract.all.find_by(description: cont_name).delete}
            m.choice "no",->{user_instance.cont_menu}
        end
        system "clear"
        puts "
        
        



        
        
                            *****🗑 🗑 🗑 🗑 🗑 🗑 [CONTRACT HAS BEEN DELETED]  🗑 🗑 🗑 🗑 🗑 🗑*****
         
        
        
        
        
        
        
        "
        sleep 3
        finder(user_instance)
    end
        

    def view_cont(cont_name,user_instance)
        obj = Cotract.all.find_by(description: cont_name)
        puts "#{obj.decription}"
        puts "#{obj.pay_out}"
        puts "#{obj.start_date}"
        # puts "#{obj.certifications}"

         sleep 3
         finder(user_instance)
         
         # name_inst = Freelancer.all.select{|m| m.name == fl_name}
    end

end