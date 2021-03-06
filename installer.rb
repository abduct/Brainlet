require "logger"
require "tty-prompt"
require "tty-command"
require "tty-spinner"
Dir.glob("src/**/*.rb") { |f| require_relative f }

config = { 
  :klipper   => "https://github.com/KevinOConnor/klipper",
  :moonraker => "https://github.com/Arksine/moonraker",
  :caddy     => "https://github.com/caddyserver/caddy/releases/download/v2.3.0/caddy_2.3.0_linux_armv7.tar.gz",
  :ui        => "https://github.com/cadriel/fluidd/releases/latest/download/fluidd.zip",
  :webcam    => "https://github.com/jacksonliam/mjpg-streamer",
  :prompt    => TTY::Prompt.new,
  :cmd       => TTY::Command.new(color: false, output: Logger.new("brainlet.log")),
  :spinner   => TTY::Spinner.new(format: :dots_2, clear: true)
}

prompt = config[:prompt]

if Process::UID.eid != 0
  prompt.error("Please run this installer with sudo...")
  exit
end

loop do
  task = prompt.select("Select a task", %w(Profile Service Recovery Maintenance Quit))

  case task
  when "Profile"
    Brainlet::Menu::profile(config)
  when "Service"
    Brainlet::Menu::service(config)
  when "Recovery"
    Brainlet::Menu::recovery(config)
  when "Maintenance"
    Brainlet::Menu::maintenance(config)
  when "Quit"
    break
  end
end
