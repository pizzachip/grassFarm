# This file is responsible for configuring your application and its
# dependencies.
#
# This configuration file is loaded before any dependency and is restricted to
# this project.
import Config

# Enable the Nerves integration with Mix
Application.start(:nerves_bootstrap)

config :grassFarm,
  target: Mix.target(),
  tomorrow_api: System.fetch_env!("TOMORROW_APIKEY")

# Customize non-Elixir parts of the firmware. See
# https://hexdocs.pm/nerves/advanced-configuration.html for details.

config :nerves, :firmware, rootfs_overlay: "rootfs_overlay"

# Set the SOURCE_DATE_EPOCH date for reproducible builds.
# See https://reproducible-builds.org/docs/source-date-epoch/ for more information

config :nerves,
  source_date_epoch: "1714758546"

config :nerves_time_zones, 
  data_dir: "./tmp/nerves_time_zones",
  default_time_zone: "America/Chicago",
  earliest_date: DateTime.to_unix(~U[2024-06-10 12:02:32Z]),
  latest_date: System.os_time(:second) + 10 * 365 * 86400

if Mix.target() == :host do
  import_config "host.exs"
else
  import_config "target.exs"
end
