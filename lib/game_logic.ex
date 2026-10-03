
defmodule CleaningTycoon.GameLogic do

  ##in the case of an empty tmp memory
  def run_game_actions(state, nil) do
     {  
      state,
      get_game_choices(state),
      %{task_mapping: %{}, selected_action: ""}
     }
  end

  #return {choices, new_tmp_frontend_memory}, 
  def run_game_actions(game_state, %{task_mapping: task_to_person_mapping, selected_action: selected_action}) do

    splited_action_list = String.split(selected_action, ".")

    action = find_action_recurse(get_game_choices(game_state), splited_action_list)

    %{game_state: new_game_state, task_map: new_task_map} = action.(game_state, task_to_person_mapping)

    {
      new_game_state,
      get_game_choices(new_game_state),
      %{task_mapping: new_task_map, selected_action: ""}
    }
  end

  defp find_action_recurse(choices, [last_selected_value]) do
    selected_action = (choices |> Enum.find(fn choice -> choice.id == last_selected_value end)).action

    selected_action
  end

  defp find_action_recurse(choices, [first_selected | rest]) do
    next_action = choices |> Enum.find(fn choice -> choice.id == first_selected end)

    find_action_recurse(next_action.subchoices, rest)
  end

  #Try to change task map to a executeable function that runs with the state as an argument
  defp get_game_choices(game_state) do
    [ %{
        id: "1", text: "Start day", action: fn(state, task_map) -> run_day(state, task_map) end
        }, 
      %{
        id: "2", text: "Study a capability", subchoices: [
          %{id: "1", text: "Study mopping", action: fn(state, task_map) -> set_study_action(state, task_map, "2.1") end 
          }, 
          %{id: "2", text: "Study vacuuming", action: fn(state, task_map) -> set_study_action(state, task_map, "2.2") end
          }
        ] 
        },
      %{
        id: "3", text: "Select a prospect for self", subchoices: map_new_cleaning_prospects_to_subchoices(game_state, "3")
       } 
    ]
  end

  def run_day(state, task_to_person_mapping) do
    new_game_state = if Map.has_key?(task_to_person_mapping, :self) do

                  mapping_components = task_to_person_mapping.self |> String.split(".")

                  case List.first(mapping_components) do
                    "2" ->
                      case List.last(mapping_components) do
                        "1" -> put_in(state, [Access.key(:my_person_properties), Access.key(:mopping)], 0.1 + get_in(state, [Access.key(:my_person_properties), Access.key(:mopping)]))
                        "2" -> put_in(state, [Access.key(:my_person_properties), Access.key(:vacuuming)], 0.1 + get_in(state, [Access.key(:my_person_properties), Access.key(:vacuuming)]))
                      end

                    "3" -> 
                      active_prospect = Enum.find(get_new_cleaning_prospects(state), fn prospect -> prospect.id == List.last(mapping_components) end) 
                      {payment, customer_satisfaction} = get_cleaning_income(state, active_prospect)
                      Map.put(state, :money, state.money + payment) |> Map.put(:reputation, state.reputation + customer_satisfaction)
                  end  
                else
                  state
                end
    %{game_state: new_game_state, task_map: %{}}
  end

  defp get_cleaning_income(state, place) do

    customer_satisfaction = get_roi_value_of_skills([state.my_person_properties.mopping, state.my_person_properties.vacuuming], 
      [place.needs_mopping, place.needs_vacuuming])
    {
      place.payment, 
      customer_satisfaction
    }
  end


  defp get_roi_value_of_skills(actual_skills, needed_skills) do
    sum = Enum.zip(actual_skills, needed_skills) |> 
    Enum.reduce(0, fn {actual, needed}, acc -> acc + 
      case actual - needed do
          x when x < 0 -> x
          x when x > 0.2 -> 0.1
          _ -> 0    
      end  
    end)     

    sum
  end


  defp get_length_of_vector(vector) do
    sum_of_squares = Enum.reduce(vector, 0, fn component, acc -> acc + component * component  end)

    :math.sqrt(sum_of_squares)
  end


  #this is called at startup, that is why it is public
  def get_new_cleaning_prospects(game_state) do
    [
     %{needs_vacuuming: 0.2, needs_mopping: 0.7, name: "Stairwells in an appartment complex", payment: 0.5, min_rep_needed: 1, id: "1"},
     %{needs_vacuuming: 0.2, needs_mopping: 0.7, name: "Street sweeping", payment: 0.5, min_rep_needed: 1, id: "2"},
     %{needs_vacuuming: 0.2, needs_mopping: 0.7, name: "Hotel", payment: 0.5, min_rep_needed: 1, id: "3"},
     %{needs_vacuuming: 0.2, needs_mopping: 0.7, name: "School classrooms and corridors", payment: 0.5, min_rep_needed: 1, id: "4"},
     %{needs_vacuuming: 0.2, needs_mopping: 0.7, name: "Bar toilets", payment: 0.5, min_rep_needed: 1, id: "5"}
   ]
    |> Enum.filter(fn prospect ->  prospect.min_rep_needed <= game_state.reputation end)
  end

  defp map_new_cleaning_prospects_to_subchoices(game_state, part_of_action) do
    get_new_cleaning_prospects(game_state) 
    |> Enum.map(fn x -> %{
        id: x.id, 
        text: x.name, 
        action: fn(state, task_map) -> %{game_state: state, task_map: Map.put(task_map, :self, part_of_action<>"."<>x.id)} end
      } end)
  end 

  defp set_study_action(game_state, task_map, selected_action) do
    new_task_map = Map.put(task_map, :self, selected_action)

    %{game_state: game_state, task_map: new_task_map}
  end

end


