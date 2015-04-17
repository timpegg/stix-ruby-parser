module Ewinparser
  def self.clean_input(value)
    input = value

    input.gsub!(/\[@\]/,"@")
    input.gsub!(/\[at\]/,"@")
    input.gsub!(/\[dot\]/,".")
    input.gsub!(/\[\.\]/,".")
    input.gsub!(/[hH][Tt]{2}[Pp]:\/\//,"")
    input.strip
    input.gsub!(/:[0-9]+.*/,"")
    input.gsub!(/\/.*/,"")
    input.gsub!(/^.*</,"")
    input.gsub!(/>.*$/,"")
    
    # check for private IP addresses
    if input =~ /(^127\.0\.0\.1)|(^10\.)|(^172\.1[6-9]\.)|(^172\.2[0-9]\.)|(^172\.3[0-1]\.)|(^192\.168\.)/
      input == nil
    end
    input
  end

  def self.clean_hash(value)
    inhash = value
    clean_output = Hash.new

    inhash.each do |k,v|
      clean_output[Ewinparser.clean_input(k)] = v unless  Ewinparser.clean_input(k).nil? 
    end

    clean_output

  end

end

