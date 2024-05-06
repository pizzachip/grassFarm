# GrassFarm

This is my new approach to building the Urban Grass Farmer application. In the first approach, I started with the user interface which was inspired by my frustrations with OpenSprinkler. However, I realized that I want something that 'just works' rather than something that gives me surgical control over creating and managing schedules.
In this version, I'm starting with the control mechanism functions that will:
* Launch a 'watering'
* Interrupt a 'watering'
* Log the results of a watering (zones + times)
* Configure the system for the number of zones connected
* Configure watering restrictions and preferences
* Connect to a weather API and configure the location
* Log local daily rainfall reported by the API
* Determination if it is time to launch a watering
* Determination if a watering should be interrupted

Then, I plan to use Fuzzy Logic to implement and tune the watering process.

1. The System will have a default set of assumptions about restrictions or preferences
2. The System will use the watering restrictions/preferences to create a predicted time to start the next watering
3. The System will use the fuzzy logic model to determine if a watering should take place and how long each station should water
4. The System will allow users to provide feedback like "grass is too dry" that will tune the model

## Targets

Nerves applications produce images for hardware targets based on the
`MIX_TARGET` environment variable. If `MIX_TARGET` is unset, `mix` builds an
image that runs on the host (e.g., your laptop). This is useful for executing
logic tests, running utilities, and debugging. Other targets are represented by
a short name like `rpi3` that maps to a Nerves system image for that platform.
All of this logic is in the generated `mix.exs` and may be customized. For more
information about targets see:

https://hexdocs.pm/nerves/supported-targets.html

## Getting Started

To start your Nerves app:
  * `export MIX_TARGET=my_target` or prefix every command with
    `MIX_TARGET=my_target`. For example, `MIX_TARGET=rpi3`
  * Install dependencies with `mix deps.get`
  * Create firmware with `mix firmware`
  * Burn to an SD card with `mix burn`

## Learn more

  * Official docs: https://hexdocs.pm/nerves/getting-started.html
  * Official website: https://nerves-project.org/
  * Forum: https://elixirforum.com/c/nerves-forum
  * Elixir Slack #nerves channel: https://elixir-slack.community/
  * Elixir Discord #nerves channel: https://discord.gg/elixir
  * Source: https://github.com/nerves-project/nerves
