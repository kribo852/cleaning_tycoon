
defmodule CleaningTycoon.GameLogic do

  ##in the case of an empty tmp memory
  def get_menu_choices(state, nil) do
     {  
      state,
      get_standard_choices(state),
      %{task_mapping: %{}, selected_action: ""}
     }
  end

  #return {choices, new_tmp_frontend_memory}, 
  def get_menu_choices(state, %{task_mapping: task_to_person_mapping, selected_action: selected}) do

    first_selected = String.split(selected, ".") |> List.first()

    case first_selected do
      "1" -> {
        run_day(state, task_to_person_mapping),
        get_standard_choices(state),
        %{task_mapping: %{}, selected_action: ""}
        }
      "2" -> {
        state,
        get_standard_choices(state),
        %{task_mapping: Map.put(task_to_person_mapping, :self, selected), selected_action: ""}#map self to a study task
        }
      "3" -> {
        state,
        get_standard_choices(state),
        %{task_mapping: Map.put(task_to_person_mapping, :self, selected), selected_action: ""}#map self to a cleaning task
      }
    end
  end

  defp get_standard_choices(game_state) do
    [ %{id: "1", text: "Start day"}, 
      %{id: "2", text: "Study a capability", subchoices: [%{id: "1", text: "Study mopping"}, %{id: "2", text: "Study vacuuming"}] },
      %{id: "3", text: "Select a prospect for self", subchoices: get_new_cleaning_prospects(game_state) |> Enum.map(fn x -> %{id: x.id, text: x.name} end) } 
    ]
  end

  def run_day(state, task_to_person_mapping) do
    if Map.has_key?(task_to_person_mapping, :self) do

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
    Enum.reduce(0, fn {actual, needed}, acc -> if needed <= 0, do: acc, else: acc + actual - needed end)     

    sum
  end


  defp get_length_of_vector(vector) do
    sum_of_squares = Enum.reduce(vector, 0, fn component, acc -> acc + component * component  end)

    :math.sqrt(sum_of_squares)
  end


  def get_new_cleaning_prospects(game_state) do
    [%{needs_vacuuming: 0.2, needs_mopping: 0.7, name: "Stairwells in an appartment complex", payment: 0.5, min_rep_needed: 1, id: "1"}]
    |> Enum.filter(fn prospect ->  prospect.min_rep_needed <= game_state.reputation end)
  end

end


