module Brainlet
  module Maintenance
    module_function

    def build(config)
      cmd     = config[:cmd]
      spinner = config[:spinner]
      prompt  = config[:prompt]

      Dir.chdir("/home/#{ENV['SUDO_USER']}/software/klipper") do
        if prompt.yes?("Would you like to run menuconfig?")
          Process.fork { exec("make menuconfig") }
          Process.wait
        end

        spinner.run do
          cmd.run "make clean"
          cmd.run "make", env: {PWD: "/home/#{ENV['SUDO_USER']}/software/klipper"}
        end
      end
    end
  end
end
