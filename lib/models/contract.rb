class Contract < ActiveRecord::Base
  belongs_to :contractor
  belongs_to :freelancer
  

  def self.tty_prompt
    prompt = TTY::Prompt.new
end


    

end
