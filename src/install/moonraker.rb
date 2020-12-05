module Brainlet
  module Install
    module_function

    def moonraker(config)
      cmd     = config[:cmd]
      spinner = config[:spinner]

      spinner.run do
        Dir.chdir("/home/#{ENV['SUDO_USER']}/software") do
          cmd.run "rm -rf moonraker"
          cmd.run "git clone --depth 1 #{config[:moonraker]} moonraker"
        end
      end
    end

    def moonraker_env(config)
      cmd     = config[:cmd]
      spinner = config[:spinner]

      spinner.run do
        Dir.chdir("/home/#{ENV['SUDO_USER']}/software") do
          cmd.run "rm -rf moonraker-env"
          cmd.run "virtualenv -p python3 /home/#{ENV['SUDO_USER']}/software/moonraker-env"

          Dir.chdir("/home/#{ENV['SUDO_USER']}/software/moonraker-env/bin") do
            cmd.run "./pip install -r /home/#{ENV['SUDO_USER']}/software/moonraker/scripts/moonraker-requirements.txt"
          end
        end
      end
    end
  end
end
