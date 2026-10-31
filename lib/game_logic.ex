
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

    %{game_state: new_game_state, tasks: new_task_map} = 
    GameStateModifyingActions.run_action(splited_action_list, game_state, task_mapping)

    {
      new_game_state,
      get_game_choices(new_game_state),
      %{task_mapping: new_task_map, selected_action: ""}
    }
  end

  #Try to change task map to a executeable function that runs with the state as an argument
  defp get_game_choices(game_state) do
    [ 
      %{ id: "1", text: "Start day" }, 
      chain_choice_options( %{ id: "2", text: "Study a capability"}, [ get_study_skills_as_options() ] ),
      %{ id: "3", text: "Select a prospect for self", subchoices: get_cleaning_prospects_as_options(game_state)},
      %{ id: "4", text: "Hire more employees", subchoices: get_potential_employees(game_state)}
    ]
  end

  defp get_cleaning_prospects_as_options(game_state) do
    GameConstants.get_standard_filtered_prospects(game_state)
    |> Enum.map(fn({prospect, index}) -> %{ id: "#{index}", text: prospect.name } end)
  end

  defp get_study_skills_as_options() do
    GameConstants.get_skills_with_index()
    |> Enum.map(fn({skill, index}) -> %{ id: "#{index}", text: Atom.to_string(skill) } end)
  end

  defp get_potential_employees(game_state) do
    GameConstants.get_available_employees_for_hire(game_state)
    |> Enum.map(fn({employee, index}) -> %{ id: "#{index}", text: employee.name } end)
  end

  #visible for testing
  def chain_choice_options([last_level_choice]) do
    last_level_choice
  end

  def chain_choice_options(first_level_choice, lower_level_choices) do
    Map.put(first_level_choice, :subchoices, chain_choice_options(lower_level_choices))
  end

  def chain_choice_options([first_level_choices | lower_level_choices]) do
    first_level_choices |> 
    Enum.map(fn(choice) -> Map.put(choice, :subchoices, chain_choice_options(lower_level_choices)) end)
  end

end
