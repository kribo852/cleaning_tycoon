
defmodule CleaningTycoon.Application do
  use Application

  @impl true
  def start(_type, _args) do

    initial_game_state = %{
        money: 5,
        reputation: 2,
        staff: [%Employee{}],
        day_counter: 1,
        random_value: CleaningTycoon.Random.get_random_value_per_day()
      }

    Supervisor.start_link([{Storage, initial_game_state}], [strategy: :one_for_one, name: CleaningTycoon.Supervisor])
  end


end
