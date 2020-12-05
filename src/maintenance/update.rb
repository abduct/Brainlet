module Brainlet
  module Maintenance
    module_function

    def update(config)
      prompt = config[:prompt]

      tasks = prompt.multi_select("Which projects do you want to update?", %w(klipper moonraker ui webcam caddy))

      tasks.each do |task|
        case task
        when "klipper"
          Brainlet::Install::klipper(config)
          Brainlet::Install::klipper_env(config)
        when "moonraker"
          Brainlet::Install::moonraker(config)
          Brainlet::Install::moonraker_env(config)
        when "ui"
          Brainlet::Install::ui(config)
        when "webcam"
          Brainlet::Install::webcam(config)
        when "caddy"
          Brainlet::Install::caddy(config)
        end
      end
    end
  end
end
