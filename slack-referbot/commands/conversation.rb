class Conversation

 #method which stores the data of referal. Starts off as empty hash
 def referal_data
   @referal_data = []
 end

 #method to check if the user really has someone to refer to
 def ask_for_referal
     print "We noticed that you might have someone to refer to for. Is that correct? Yes/No"
     answer = gets.chomp.to_s
     answer.downcase
   if answer == n || answer == no
     print "Too bad. Maybe next time ;)"
   else
     #continue with
   end

 end

 #method that obtains the name of the referal
 def get_full_name
   print "Good to hear you want to refer to someone. You might earn € 1000!"
   sleep(0.5)
   print "What is your contacts full name?"
   @name = gets.chomp

   while @name.empty?
     print "Please enter a name."
     @name = gets.chomp
   end
 end

 #adding name to referal_data hash
 #@referal_data.store(:full_name,  get_full_name)


 #methode to obtain the mail of the referal
 #not finished
 def get_email
   print "what is your contacts email?"
   @mail = gets.chomp
 end

 #method to get the phone number
 #not finished
 def get_phone
 end

 #What else will we ask? linkedin? github?

 #conversation method combining all the above methods
 def conversation
 end



end
