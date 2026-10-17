
defmodule CleaningTycoon.Application do
  use Application

  @impl true
  def start(_type, _args) do

    initial_game_state = %{
        money: 10,
        reputation: 5,
        staff: [%{name: "Molly Manager", vacuuming: 0.3, mopping: 0.3, can_fire: false}],
        day_counter: 1
      }

    Supervisor.start_link([{Storage, initial_game_state}], [strategy: :one_for_one, name: CleaningTycoon.Supervisor])
  end


end
