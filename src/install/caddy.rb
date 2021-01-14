require "socket"

module Brainlet
  module Install
    module_function

    def caddy(config)
      cmd     = config[:cmd]
      spinner = config[:spinner]

      spinner.run do
        Dir.chdir("/home/#{ENV['SUDO_USER']}/software") do
          cmd.run "rm -rf caddy"
          cmd.run "mkdir caddy"
          Dir.chdir("/home/#{ENV['SUDO_USER']}/software/caddy") do
            cmd.run "wget -q -O caddy.tar.gz #{config[:caddy]}"
            cmd.run "tar xfs caddy.tar.gz"
            cmd.run "rm -rf ./caddy.tar.gz LICENSE README.md"
          end
        end

        cmd.run "cp ./resources/caddy/caddy.service /etc/systemd/system/caddy.service"
        cmd.run "sed -i -e 's|$NAME|#{ENV['SUDO_USER']}|g' /etc/systemd/system/caddy.service"
        cmd.run "chmod 664 /etc/systemd/system/caddy.service"
        cmd.run "systemctl enable caddy.service"
        cmd.run "systemctl stop caddy.service"

        cmd.run "cp ./resources/caddy/caddy.cfg /home/#{ENV['SUDO_USER']}/software/caddy/caddy.cfg"
        cmd.run "sed -i -e 's|$NAME|#{ENV['SUDO_USER']}|g' /home/#{ENV['SUDO_USER']}/software/caddy/caddy.cfg"

        cmd.run "systemctl start caddy.service"
      end
    end
  end
end
