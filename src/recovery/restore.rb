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
        name = prompt.select("Which printer would you like to restore?", printer_profiles)
        break if prompt.yes?("Are you sure you would like to restore #{name}?")
      end

      spinner.run do
        Dir.chdir("/home/#{ENV['SUDO_USER']}") do
          cmd.run "rm -rf configs/#{name}/"
          cmd.run "mkdir -p configs/#{name}"
          cmd.run "cp -r recovery/configs/#{name}/* configs/#{name}/"
          cmd.run "cp -r recovery/services/#{name}/* /etc/systemd/system/"

          cmd.run "chown -R #{ENV['SUDO_USER']}:#{ENV['SUDO_USER']} configs"
        end
      end
    end

    def restore_all(config)
      cmd     = config[:cmd]
      prompt  = config[:prompt]
      spinner = config[:spinner]

      return if prompt.no?("Are you sure you would like to restore all profiles?")

      spinner.run do
        printer_profiles = []
        Dir.chdir("/home/#{ENV['SUDO_USER']}/recovery/configs") do
          printer_profiles = Dir.glob("*").select { |f| File.directory? f }
        end

        Dir.chdir("/home/#{ENV['SUDO_USER']}") do
          printer_profiles.each do |name|
            cmd.run "rm -rf configs/#{name}/"
            cmd.run "mkdir -p configs/#{name}"
            cmd.run "cp -r recovery/configs/#{name}/* configs/#{name}/"
            cmd.run "cp -r recovery/services/#{name}/* /etc/systemd/system/"

            cmd.run "chown -R #{ENV['SUDO_USER']}:#{ENV['SUDO_USER']} configs"
          end
        end
      end
    end
  end
end
