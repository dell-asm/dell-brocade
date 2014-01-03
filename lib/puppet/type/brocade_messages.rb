module Puppet::Type::Brocade_messages

     ALIAS_NAME_BLANK_ERROR="Unable to perform the operation because the alias name is blank."
     ALIAS_NAME_SPECIAL_CHAR_ERROR="Unable to perform the operation because the alias name contains special characters."
	 MEMBER_WWPN_INVALID_FORMAT_ERROR="Enter a correct MemberWWPN value. A valid MemberWWPN value must be in XX:XX:XX:XX:XX:XX:XX:XX format." 
	 MEMBER_WWPN_BLANK_ERROR="MemberWWPN value cannot be blank. A valid MemberWWPN value must be in XX:XX:XX:XX:XX:XX:XX:XX format."
	 
	 CONFIG_NAME_BLANK_ERROR="Unable to perform the operation because the zone config name is blank."
	 CONFIG_NAME_SPECIAL_CHAR_ERROR="Unable to perform the operation because the zone config name contains special characters."
	 
	 ZONE_NAME_BLANK_ERROR="Unable to perform the operation because the zone name is blank."
	 ZONE_NAME_SPECIAL_CHAR_ERROR="Unable to perform the operation because the zone name contains special characters."
	 ZONE_MEMBER_BLANK_ERROR="Unable to perform the operation because the member is blank."
	 
  def empty_value_check(value, error)
    if value.strip.length == 0
      raise ArgumentError, error
    end
  end

  def special_char_check(value, error)
    if ( value =~ /[\W]+/ )
       raise ArgumentError, error
    end
  end

  def tokenize_list(value)
  @token = []
  @token = value.split(";")
  @token
  end

  def member_value_format_check(value)
    tokenize_list(value).each do |line|
      if ( line.strip =~ /[:]+/ )
        member_wwpn_format_check(line.strip, MEMBER_WWPN_INVALID_FORMAT_ERROR)
      else
        special_char_check(line.strip, ALIAS_NAME_SPECIAL_CHAR_ERROR)
      end
    end
  end

  
  def list_special_char_check(value, error)
    tokenize_list(value).each do |line|
        special_char_check(line.strip, error)
	end
  end
		
  def member_wwpn_format_check(item, error)
    unless item  =~ /^([0-9a-f]{2}:){7}[0-9a-f]{2}$/
      raise ArgumentError, error
    end
  end
	 
  module_function :empty_value_check, :special_char_check, :member_value_format_check, :member_wwpn_format_check, :tokenize_list, :list_special_char_check

end
