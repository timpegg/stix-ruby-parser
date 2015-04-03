require 'stringio'

module Ewinparser
  class Printer
    def self.print_ticket (file_array, io=$stdout)
      @files = file_array
      #      @results = results_hash
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

      @output.puts "-" * 25
      @output.puts "Emails"
      @output.puts "-" * 25

      @emails = Ewinparser::Ewinstore.get_emails
      @emails.sort_by!{|word| word.downcase}
      @emails.each do |email|
        @output.puts(email)
      end

      @output.puts "\n"

      @output.puts "-" * 25
      @output.puts "URLs"
      @output.puts "-" * 25

      @domains = Ewinparser::Ewinstore.get_domains
      @domains.sort_by!{|word| word.downcase}
      @domains.each do |domain|
        #        @output.puts("http://#{domain}")
        #        @output.puts("https://#{domain}")
        @output.puts("#{domain}")
      end

      @output.puts "\n"

      @output.puts "-" * 25
      @output.puts "IPs"
      @output.puts "-" * 25

      @ips = Ewinparser::Ewinstore.get_ips
      @ips.sort_by! {|ip| ip.split('.').map{ |octet| octet.to_i} }
      @ips.each do |ip|
        @output.puts(ip)
      end

      @output.puts "\n"

      #      @output.puts(arg1)

    end

    def self.print_emails(results_hash, io=$stdout)
      @io = io

    end

    def self.print_domains(results_hash, io=$stdout)
      @io = io

    end

    def self.print_ips(results_hash, io=$stdout)

    end
  end

end

