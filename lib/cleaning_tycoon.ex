
defmodule CleaningTycoon.Application do
  use Application

  @impl true
  def start(_type, _args) do

    initial_game_state = %{
        prospects: [],
        money: 10,
        reputation: 5,
        my_person_properties: %{vacuuming: 0.3, mopping: 0.3}
      }

      Map.put(initial_game_state, :prospects, CleaningTycoon.GameLogic.get_new_cleaning_prospects(initial_game_state))

    Supervisor.start_link([{Storage, initial_game_state}], [strategy: :one_for_one, name: CleaningTycoon.Supervisor])
  end


end
