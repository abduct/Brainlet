module Brainlet
  module Recovery
    module_function

    def restore(config)
      cmd     = config[:cmd]
      prompt  = config[:prompt]
      spinner = config[:spinner]

      name = ""

      printer_profiles = []
      Dir.chdir("/home/#{ENV['SUDO_USER']}/recovery/configs") do
        printer_profiles = Dir.glob("*").select { |f| File.directory? f }
      end

      loop do
        name = prompt.select("Which printer would you like to backup?", printer_profiles)
        break if prompt.yes?("Are you sure you would like to backup #{name}?")
      end

      spinner.run do
        Dir.chdir("/home/#{ENV['SUDO_USER']}") do
          cmd.run "mkdir -p configs/#{name}"
          cmd.run "cp recovery/configs/#{name}/printer.cfg configs/#{name}/"
          cmd.run "cp recovery/services/#{name}/* /etc/systemd/system/"
        end
      end
    end

    def restore_all(config)
      cmd     = config[:cmd]
      prompt  = config[:prompt]
      spinner = config[:spinner]

      spinner.run do
        printer_profiles = []
        Dir.chdir("/home/#{ENV['SUDO_USER']}/recovery/configs") do
          printer_profiles = Dir.glob("*").select { |f| File.directory? f }
        end

        printer_profiles.each do |name|
          cmd.run "mkdir -p configs/#{name}"
          cmd.run "cp recovery/configs/#{name}/printer.cfg configs/#{name}/"
          cmd.run "cp recovery/services/#{name}/* /etc/systemd/system/"
        end
      end
    end
  end
end
