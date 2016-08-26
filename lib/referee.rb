class Referee

  def initialize
    @states = {
      in_conversation: false,
      get_name: false,
      get_email: false,
      get_vacancy: false,
      input_gathered: false
    }

    @attributes = {
      name: '',
      email: '',
      vacancy: ''
    }
  end

  def reformat_email
    if /\|/.match(@attributes[:email])
      @attributes[:email] = @attributes[:email].split('|')[1].chomp('>')
    end
  end

  attr_accessor :states, :attributes

end
