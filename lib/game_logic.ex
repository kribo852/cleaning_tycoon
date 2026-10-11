
defmodule CleaningTycoon.GameLogic do
  alias CleaningTycoon.GameConstants
  alias CleaningTycoon.GameStateModifyingActions


  ##in the case of an empty tmp memory
  def run_game_actions(state, nil) do
     {  
      state,
      get_game_choices(state),
      %{task_mapping: [], selected_action: ""}
     }
  end


  #return {choices, new_tmp_frontend_memory}, 
  def run_game_actions(game_state, %{task_mapping: task_mapping, selected_action: selected_action}) do

    splited_action_list = String.split(selected_action, ".")

    %{game_state: new_game_state, tasks: new_task_map} = GameStateModifyingActions.run_action(splited_action_list, game_state, task_mapping)

    {
      new_game_state,
      get_game_choices(new_game_state),
      %{task_mapping: new_task_map, selected_action: ""}
    }
  end

  #Try to change task map to a executeable function that runs with the state as an argument
  defp get_game_choices(game_state) do
    [ %{ id: "1", text: "Start day" }, 
      %{
        id: "2", text: "Study a capability", subchoices: [
          %{id: "1", text: "Study mopping" }, 
          %{ id: "2", text: "Study vacuuming" }
        ] 
        },
      %{ id: "3", text: "Select a prospect for self", subchoices: get_cleaning_prospects_as_options()
      } 
    ]
  end

  defp get_cleaning_prospects_as_options() do
    GameConstants.get_all_cleaning_prospects_with_index()
    |> Enum.map(fn({prospect, index}) -> %{ id: "#{index}", text: prospect.name } end)

  end

end
