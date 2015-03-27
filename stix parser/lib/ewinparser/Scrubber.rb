module Ewinparser
  class Scrubber
    def initialize(input)
      @input = input
      clean_input(@input)
    end

    def clean_input(input)
      @input = input

      @input.gsub!(/\[@\]/,"@")
      @input.gsub!(/\[at\]/,"@")
      @input.gsub!(/\[dot\]/,".")
      @input.gsub!(/\[\.\]/,".")
      @input.gsub!(/[hH][Tt]{2}[Pp]:\/\//,"")
      @input.gsub!(/:[0-9]+.*/,"")
#      @input.gsub!(/:[0-9]+.*/,"")
      
      
    end
    private :clean_input
    
    def to_s()
      @input
    end
    
  end
end


puts Ewinparser::Scrubber.new('me[at]somting.com')
puts Ewinparser::Scrubber.new('hTtp://me[at]somting.com')
puts Ewinparser::Scrubber.new('hTtp://me[at]somting.com:865/morejunk/')
puts Ewinparser::Scrubber.new('hTtp://me[at]somting.com/morejunk/')

