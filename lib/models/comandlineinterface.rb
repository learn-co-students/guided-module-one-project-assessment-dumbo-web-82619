class ComandLineInterface 

    attr_accessor :prompt, :user, :pastel
    
    def initialize()
    @prompt = TTY::Prompt.new(symbols: {tick: '√'}, active_color: :cyan)
    @pastel = Pastel.new
    end
    
    def greet
        system "clear"
       
        puts pastel.decorate("**********************Welcome to  C.F.A************************", :bright_green)
        
        self.art_work
        sleep 3
        
    
        # choice = self.prompt.select("Are you a ...") do |m|
        #     m.choice "CONTRACTOR"
        #     m.choice "FREELANCER"
        # end
        # case choice
        # when "CONTRACTOR"
        puts "Hello Contractor"
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
            m.choice "view freelancers",->{user_instance.my_freelancers(self)}
            m.choice "View contracts",->{user_instance.my_contracts(self)}
            m.choice "[LOG_OUT]",->{exit_cont_menu}
        end
        
    end
    
    
    # def self.cont_menu(user_instance)
    #     cont_menu(user_instance)
    # end
    # def fl_menu
    #     system "clear"
    #     choice = self.prompt.select("What would you like to do today") do |m|
    #         m.choice "Update your bio ?",->{user_instance.update_bio(self)}
    #         m.choice "View your contracts ?",->{self.user.my_contracts(self) }
    #         m.choice "[LOG_OUT]",->{}
#    end
# end

def exit_cont_menu
    puts "🔚"
    sleep 1
    puts "🔚🔚🔚🔚" 
    sleep 1
    puts "🔚🔚🔚🔚🔚🔚🔚🔚🔚🔚"
    sleep 1
    puts "🔚🔚🔚🔚🔚🔚🔚🔚🔚🔚🔚🔚🔚🔚🔚🔚🔚🔚"
    sleep 1
    puts "🔚🔚🔚🔚🔚🔚🔚🔚🔚🔚🔚🔚🔚🔚🔚🔚🔚🔚🔚🔚🔚🔚🔚🔚🔚🔚🔚🔚🔚🔚🔚🔚"
    puts "      
    

    

    

    
    
**********[GOOD BYE]**********








"
exit
end

def self.exit_cont_menu
    system "clear"
    puts "🔚"
    sleep 1
    puts "🔚🔚🔚🔚" 
    sleep 1
    puts "🔚🔚🔚🔚🔚🔚🔚🔚🔚🔚"
    sleep 1
    puts "🔚🔚🔚🔚🔚🔚🔚🔚🔚🔚🔚🔚🔚🔚🔚🔚🔚🔚"
    sleep 1
    puts "🔚🔚🔚🔚🔚🔚🔚🔚🔚🔚🔚🔚🔚🔚🔚🔚🔚🔚🔚🔚🔚🔚🔚🔚🔚🔚🔚🔚🔚🔚🔚🔚"
    puts "      
    

    
    
    
    

    
**********[GOOD BYE]**********








"
exit
end




#     def art_work
#         art = puts "[
#                                    _
#                                  ,d8b,
#                          _,,aadd8888888bbaa,,_
#                     _,ad88P"""8,  I8I  ,8"""Y88ba,_
#                  ,ad88P" `Ya  `8, `8' ,8'  aP' "Y88ba,
#                ,d8"' "Yb   "b, `b  8  d' ,d"   dP" `"8b,
#               dP"Yb,  `Yb,  `8, 8  8  8 ,8'  ,dP'  ,dP"Yb
#            ,ad8b, `Yb,  "Ya  `b Y, 8 ,P d'  aP"  ,dP' ,d8ba,
#           dP" `Y8b, `Yb, `Yb, Y,`8 8 8',P ,dP' ,dP' ,d8P' "Yb
#          ,88888888Yb, `Yb,`Yb,`8 8 8 8 8',dP',dP' ,dY88888888,
#          dP     `Yb`Yb, Yb,`8b 8 8 8 8 8 d8',dP ,dP'dP'     Yb
#         ,8888888888b "8, Yba888888888888888adP ,8" d8888888888,
#         dP        `Yb,`Y8P""'             `""Y8P',dP'        Yb
#        ,88888888888P"Y8P'_.---.._     _..---._`Y8P"Y88888888888,
#        dP         d'  8 '  ____  `. .'  ____  ` 8  `b         Yb
#       ,888888888888   8   <(@@)>  | |  <(@@)>   8   888888888888,
#       dP          8   8    `"""         """'    8   8          Yb
#      ,8888888888888,  8          ,   ,          8  ,8888888888888,
#      dP           `b  8,        (.-_-.)        ,8  d'           Yb
#     ,88888888888888Yaa8b      .'       `.      d8aaP88888888888888,
#     dP               ""8b     _,gd888bg,_     d8""               Yb
#    ,888888888888888888888b,    ""Y888P""    ,d888888888888888888888,
#    dP                   "8"b,             ,d"8"                   Yb
#   ,888888888888888888888888,"Ya,_,ggg,_,aP",888888888888888888888888,
#   dP                      "8,  "8"\x/"8"  ,8"                      Yb
#  ,88888888888888888888888888b   8\\x//8   d88888888888888888888888888,
#  8888bgg,_                  8   8\\x//8   8                  _,ggd8888
#   `"Yb, ""8888888888888888888   Y\\x//P   8888888888888888888"" ,dP"'
#     _d8bg,_"8,              8   `b\x/d'   8              ,8"_,gd8b_
#   ,iP"   "Yb,8888888888888888    8\x/8    8888888888888888,dP"  `"Yi,
#  ,P"    __,888              8    8\x/8    8              888,__    "Y,
# ,8baaad8P"":Y8888888888888888 aaa8\x/8aaa 8888888888888888P:""Y8baaad8,
# dP"':::::::::8              8 8::8\x/8::8 8              8:::::::::`"Yb
# 8::::::::::::8888888888888888 8::88888::8 8888888888888888::::::::::::8
# 8::::::::::::8,             8 8:::::::::8 8             ,8::::::::::::8
# 8::::::::::::8888888888888888 8:::::::::8 8888888888888888::::::::::::8
# 8::::::::::::Ya             8 8:::::::::8 8             aP::::::::::::8
# 8:::::::::::::888888888888888 8:::::::::8 888888888888888:::::::::::::8
# 8:::::::::::::Ya            8 8:::::::::8 8            aP:::::::::::::8
# Ya:::::::::::::88888888888888 8:::::::::8 88888888888888:::::::::::::aP
# `8;:::::::::::::Ya,         8 8:::::::::8 8         ,aP:::::::::::::;8'
#  Ya:::::::::::::::"Y888888888 8:::::::::8 888888888P":::::::::::::::aP
#  `8;::::::::::::::::::::""""Y8888888888888P""""::::::::::::::::::::;8'
#   Ya:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::aP
#    "b;::::::::::::::::::::::::::::::::::::::::::: Normand  ::::::;d"
#     `Ya;::::::::::::::::::::::::::::::::::::::::: Veilleux ::::;aP'
#       `Ya;:::::::::::::::::::::::::::::::::::::::::::::::::::;aP'
#          "Ya;:::::::::::::::::::::::::::::::::::::::::::::;aP"
#             "Yba;;;:::::::::::::::::::::::::::::::::;;;adP"
#                 `"""""""Y888888888888888888888P"""""""'

#     ]"
# end 
    
def art_work
art= puts <<-"EOF"
           '
            *          .
                   *       '
              *                *





   *   '*
           *
                *
                       *
               *
                     *

         .                      .
         .                      ;
         :                  - --+- -
         !           .          !
         |        .             .
         |_         +
      ,  | `.
--- --+-<#>-+- ---  --  -
      `._|_,'
         T
         |
         !
         :         . : 
         .       *


 EOF
art
end
 end