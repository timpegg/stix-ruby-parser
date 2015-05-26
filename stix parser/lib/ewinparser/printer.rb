require 'stringio'
require 'pathname'

module Ewinparser
  class Printer
    def self.add_date()
      Time.now.strftime('%Y%m%d-%H.%M.%S')
    end

    def self.sort(array)
      if @entry =~ /\b(?:\d{1,3}\.){3}\d{1,3}\b/
        array.sort_by! {|ip| ip.split('.').map{ |octet| octet.to_i} }
      else
        array.sort_by!{|word| word.downcase}
      end
    end

    def self.file_io(io = $stdout)
      if io == $stdout
        file_descriptor = io.fileno
        IO.new(file_descriptor,"w")
      else
        file_descriptor = IO.sysopen(io,"w")
        if config.datefile
          IO.new("#{self.add_date()}-#{file_descriptor}","w")
        else
          IO.new("#{file_descriptor}","w")
        end
      end

    end

    def self.print_webfilter_ticket()

      domains = Ewinparser::Ewinstore.get_domains
      output = file_io(config.outputfile)
       
      if !domains.nil?
        domains.each do |domain|
          output.puts("http://#{domain}")
          output.puts("https://#{domain}")
        end

      end

    end

    def self.print_ticket (file_array, io=$stdout)
      @files = file_array
      @io = io

      if @io == $stdout
        @file_descriptor = @io.fileno
        @output_ticket = IO.new(@file_descriptor,"w")
        @output_firewall = @output_ticket
        @out_webfilter = @output_ticket
        @output_emailfilter = @output_ticket

      else
        @file_base = File.basename(@io, ".*")
        @file_path = Pathname.new(@io).dirname

        @file_descriptor = IO.sysopen(@io,"w")
        @output_ticket = IO.new(@file_descriptor,"w")

        @file_base = File.basename(@io, ".*")
        @file_descriptor = IO.sysopen("#{@file_path}\\#{@file_base}_firewall.txt","w")
        @output_firewall = IO.new(@file_descriptor,"w")

        @file_descriptor = IO.sysopen("#{@file_path}\\#{@file_base}_webfilter.txt","w")
        @output_webfilter = IO.new(@file_descriptor,"w")

        @file_descriptor = IO.sysopen("#{@file_path}\\#{@file_base}_emailfilter.txt","w")
        @output_emailfilter = IO.new(@file_descriptor,"w")

      end

      @output_ticket.puts "EWIN Bulletins:"
      @output_ticket.puts "-" * 25
      @files.each do | file |
        @output_ticket.puts(file)
      end

      @output_emailfilter.puts "-" * 25
      @output_emailfilter.puts "Emails"
      @output_emailfilter.puts "-" * 25

      @emails = Ewinparser::Ewinstore.get_emails

      if !@emails.nil?
        @linebreak = 1
        @emails.sort_by!{|word| word.downcase}
        @emails.each do |email|
          @linebreak += 1
          @output_emailfilter.puts if (@linebreak % 200) == 0
          @output_emailfilter.puts(email  + ';')
        end

        @emails = Ewinparser::Ewinstore.get_added_emails

        @output_emailfilter.puts "\n"
        @output_emailfilter.puts "-" * 25
        @output_emailfilter.puts "Emails - Added"
        @output_emailfilter.puts "-" * 25

        if !@emails.nil?
          @emails.sort_by!{|word| word.downcase}
          @emails.each do |email|
            @output_emailfilter.puts(email + ';')
          end
        end

        @emails = Ewinparser::Ewinstore.get_removed_emails

        @output_emailfilter.puts "\n"
        @output_emailfilter.puts "-" * 25
        @output_emailfilter.puts "Emails - Removed"
        @output_emailfilter.puts "-" * 25

        if !@emails.nil?

          @emails.sort_by!{|word| word.downcase}
          @emails.each do |email|
            @output_emailfilter.puts(email + ';')
          end
        end

      end

      @output_webfilter.puts "-" * 25
      @output_webfilter.puts "URLs"
      @output_webfilter.puts "-" * 25

      @domains = Ewinparser::Ewinstore.get_added_domains

      if !@domains.nil?
        @domains.sort_by!{|word| word.downcase}
        @domains.each do |domain|
          @output_webfilter.puts("http://#{domain}")
          @output_webfilter.puts("https://#{domain}")
        end

      end

      @ips = Ewinparser::Ewinstore.get_added_ips
      @output_firewall.puts "-" * 25
      @output_firewall.puts "IPs - Added"
      @output_firewall.puts "-" * 25

      if !@ips.nil?
        @ips.sort_by! {|ip| ip.split('.').map{ |octet| octet.to_i} }
        @ips.each do |ip|
          @output_firewall.puts(ip)
        end
      end

      @ips = Ewinparser::Ewinstore.get_removed_ips

      @output_firewall.puts "\n"
      @output_firewall.puts "-" * 25
      @output_firewall.puts "IPs - Removed"
      @output_firewall.puts "-" * 25

      if !@ips.nil?
        @ips.sort_by! {|ip| ip.split('.').map{ |octet| octet.to_i} }
        @ips.each do |ip|
          @output_firewall.puts(ip)
        end
      end

      @output_firewall.puts "\n"
      @output_firewall.puts "-" * 25
      @output_firewall.puts "IPs"
      @output_firewall.puts "-" * 25

      @ips = Ewinparser::Ewinstore.get_ips
      if !@ips.nil?
        @ips.sort_by! {|ip| ip.split('.').map{ |octet| octet.to_i} }
        @ips.each do |ip|
          @output_firewall.puts(ip)
        end
      end

    end

  end

end

