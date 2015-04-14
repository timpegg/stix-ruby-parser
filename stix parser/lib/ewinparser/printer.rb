require 'stringio'

module Ewinparser
  class Printer
    #TODO Separate output into differnet files
    def self.print_ticket (file_array, io=$stdout)
      @files = file_array
      @io = io

      if @io == $stdout
        @file_descriptor = @io.fileno
      else
        @file_descriptor = IO.sysopen(@io,"w")
      end
      @output = IO.new(@file_descriptor,"w")

      @output.puts "EWIN Bulletins:"
      @output.puts "-" * 25
      @files.each do | file |
        @output.puts(file)
      end

      @output.puts "\n"
      @output.puts "\n"

      @output.puts "-" * 25
      @output.puts "Emails"
      @output.puts "-" * 25

      @emails = Ewinparser::Ewinstore.get_emails
      
      
      if !@emails.nil?
        @linebreak = 1
        @emails.sort_by!{|word| word.downcase}
        @emails.each do |email|
          @linebreak += 1
          @output.puts if (@linebreak % 200) == 0
          @output.puts(email  + ';')
        end

        @emails = Ewinparser::Ewinstore.get_added_emails

        @output.puts "\n"
        @output.puts "-" * 25
        @output.puts "Emails - Added"
        @output.puts "-" * 25

        if !@emails.nil?
          @emails.sort_by!{|word| word.downcase}
          @emails.each do |email|
            @output.puts(email + ';')
          end
        end

        @emails = Ewinparser::Ewinstore.get_removed_emails

        @output.puts "\n"
        @output.puts "-" * 25
        @output.puts "Emails - Removed"
        @output.puts "-" * 25

        if !@emails.nil?

          @emails.sort_by!{|word| word.downcase}
          @emails.each do |email|
            @output.puts(email + ';')
          end
        end

      end

      @output.puts "\n"
      @output.puts "\n"

      @output.puts "-" * 25
      @output.puts "URLs"
      @output.puts "-" * 25

      @domains = Ewinparser::Ewinstore.get_domains

      if !@domains.nil?
        @domains.sort_by!{|word| word.downcase}
        @domains.each do |domain|
          @output.puts("http://#{domain}")
          @output.puts("https://#{domain}")
        end

      end

      @domains = Ewinparser::Ewinstore.get_added_domains

      #      if !@domains.nil?
      #        @output.puts "\n"
      #
      #        @output.puts "-" * 25
      #        @output.puts "URLs - Added"
      #        @output.puts "-" * 25
      #        @domains.sort_by!{|word| word.downcase}
      #        @domains.each do |domain|
      #          @output.puts("http://#{domain}")
      #          @output.puts("https://#{domain}")
      #        end
      #
      #      end
      #
      #      @domains = Ewinparser::Ewinstore.get_removed_domains
      #
      #      if !@domains.nil?
      #        @output.puts "\n"
      #
      #        @output.puts "-" * 25
      #        @output.puts "URLs - Removed"
      #        @output.puts "-" * 25
      #
      #        @domains.sort_by!{|word| word.downcase}
      #        @domains.each do |domain|
      #          @output.puts("http://#{domain}")
      #          @output.puts("https://#{domain}")
      #        end
      #
      #      end

      @output.puts "\n"
      @output.puts "\n"

      @output.puts "-" * 25
      @output.puts "IPs"
      @output.puts "-" * 25

      @ips = Ewinparser::Ewinstore.get_ips
      if !@ips.nil?
        @ips.sort_by! {|ip| ip.split('.').map{ |octet| octet.to_i} }
        @ips.each do |ip|
          @output.puts(ip)
        end
      end

      @ips = Ewinparser::Ewinstore.get_added_ips

      @output.puts "\n"
      @output.puts "-" * 25
      @output.puts "IPs - Added"
      @output.puts "-" * 25

      if !@ips.nil?
        @ips.sort_by! {|ip| ip.split('.').map{ |octet| octet.to_i} }
        @ips.each do |ip|
          @output.puts(ip)
        end
      end

      @ips = Ewinparser::Ewinstore.get_removed_ips

      @output.puts "\n"
      @output.puts "-" * 25
      @output.puts "IPs - Removed"
      @output.puts "-" * 25

      if !@ips.nil?
        @ips.sort_by! {|ip| ip.split('.').map{ |octet| octet.to_i} }
        @ips.each do |ip|
          @output.puts(ip)
        end
      end

    end

  end

end

