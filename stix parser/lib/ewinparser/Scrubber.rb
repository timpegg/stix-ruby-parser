module Ewinparser
  
    def self.clean_input(input)
      @input = input
      
      @input = @input.gsub(/\[@\]/,"@")
      @input = @input.gsub(/\[at\]/,"@")
      @input = @input.gsub(/\[dot\]/,".")
      @input = @input.gsub(/\[\.\]/,".")
      @input = @input.gsub(/[hH][Tt]{2}[Pp]:\/\//,"")
      @input = @input.gsub(/:[0-9]+.*/,"")
      @input = @input.gsub(/\/.*/,"")
      @input = @input.gsub(/^.*</,"")
      @input = @input.gsub(/>.*$/,"")
            
      @input
    end

end

