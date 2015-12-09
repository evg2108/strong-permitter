module StrongPermitter
  class Cli
    def self.start(*args)
      if args.length != 1
        puts "Unknown command format. Please use 'strong_permitter -h' for more information."
        return
      end

      case args.first
        when '--help', '-h'
          puts 'Commands format: strong_permitter <command>'
          puts 'Available commands:'
          puts "\tinstall\t- Create initializer for Rails application"
        when 'install'
          print 'Creating config/initializers/strong_permitter.rb'
          if File.exist?('config/initializers/strong_permitter.rb')
            puts "\t(already exist - skipped)"
          else
            FileUtils.cp(File.expand_path('../templates/initializer.rb', __FILE__), 'config/initializers/strong_permitter.rb')
            puts "\t(ok)"
          end

          print 'Making directory app/controllers/permissions'
          if Dir.exist?('app/controllers/permissions')
            puts "\t\t(already exist - skipped)"
          else
            FileUtils.mkpath 'app/controllers/permissions'
            puts "\t\t(ok)"
          end

      end
    end
  end
end