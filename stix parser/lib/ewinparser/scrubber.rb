module Ewinparser
  def self.clean_input(input)
    @input = input

    @input = @input.gsub(/\[@\]/,"@")
    @input = @input.gsub(/\[at\]/,"@")
    @input = @input.gsub(/\[dot\]/,".")
    @input = @input.gsub(/\[\.\]/,".")
    @input = @input.gsub(/[hH][Tt]{2}[Pp]:\/\//,"")
    @input = @input.strip
    @input = @input.gsub(/:[0-9]+.*/,"")
    @input = @input.gsub(/\/.*/,"")
    @input = @input.gsub(/^.*</,"")
    @input = @input.gsub(/>.*$/,"")
    
    # check for private IP addresses
    if @input =~ /(^127\.0\.0\.1)|(^10\.)|(^172\.1[6-9]\.)|(^172\.2[0-9]\.)|(^172\.3[0-1]\.)|(^192\.168\.)/
      @input = nil
    end
    @input
  end

  def self.clean_hash(hash)
    @inhash = hash

    @clean_output = Hash.new

    @inhash.each do |k,v|
      @key = Ewinparser.clean_input(k)
      @clean_output[@key] = v unless  @key.nil? 
      
    end

    @clean_output

  end

end

