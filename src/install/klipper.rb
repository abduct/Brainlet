module Brainlet
  module Install
    module_function

    def klipper(config)
      cmd     = config[:cmd]
      spinner = config[:spinner]

      spinner.run do
        Dir.chdir("/home/#{ENV['SUDO_USER']}/software") do
          cmd.run "rm -rf klipper"
          cmd.run "git clone --depth 1 #{config[:klipper]} klipper"
        end
      end
    end

    def klipper_env(config)
      cmd     = config[:cmd]
      spinner = config[:spinner]

      spinner.run do
        Dir.chdir("/home/#{ENV['SUDO_USER']}/software") do
          cmd.run "rm -rf klipper-env"
          cmd.run "virtualenv -p python2 /home/#{ENV['SUDO_USER']}/software/klipper-env"

          Dir.chdir("/home/#{ENV['SUDO_USER']}/software/klipper-env/bin") do
            cmd.run "./pip install --upgrade setuptools"
            cmd.run "./pip install -r /home/#{ENV['SUDO_USER']}/software/klipper/scripts/klippy-requirements.txt"
          end
        end
      end
    end
  end
end
