module Brainlet
  module Install
    module_function

    def ui(config)
      cmd     = config[:cmd]
      spinner = config[:spinner]

      spinner.run do
        Dir.chdir("/home/#{ENV['SUDO_USER']}/software") do
          cmd.run "rm -rf ui"
          cmd.run "mkdir ui"

          Dir.chdir("/home/#{ENV['SUDO_USER']}/software/ui") do
            cmd.run "wget -q -O ui.zip #{config[:ui]}"
            cmd.run "unzip -o ui.zip"
            cmd.run "rm -rf ui.zip"
          end
        end
      end
    end
  end
end
