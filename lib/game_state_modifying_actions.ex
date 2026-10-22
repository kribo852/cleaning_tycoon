
defmodule CleaningTycoon.GameStateModifyingActions do
	alias CleaningTycoon.GameConstants

	def run_action(["1"], game_state, []) do ## run day no tasks left in the task map
		%{game_state: %{game_state | day_counter: game_state.day_counter + 1 }, tasks: []}
	end

	def run_action(["1"], game_state, [first_task | rest_tasks]) do ## run day
		new_game_state = run_day_action(first_task, game_state) 

		run_action(["1"], new_game_state, rest_tasks)
	end

	def run_action([_ | _] = action, game_state, tasks) do ## add a task to task map
		%{game_state: game_state, tasks: [action | tasks]}
	end

	defp run_day_action(["2", skill_option_number], game_state) do ## learn a skill
		skill_atom = GameConstants.get_skills_with_index()
		|> Enum.find(fn({_skill, index}) -> String.to_integer(skill_option_number) == index end)
		|> elem(0)

		current_person = List.first(game_state.staff)
		current_person_skills = current_person.skills

		updated_skills = Map.put(current_person_skills, skill_atom, 0.1 + Map.get(current_person_skills, skill_atom, 0))

		updated_staff_list = game_state.staff
		|> Enum.map(fn(employee) -> if employee.name == current_person.name, do: %{employee | skills: updated_skills}, else: employee end)

		%{game_state | staff: updated_staff_list}
	end

	defp run_day_action(["3", prospect_number], game_state) do
		prospect = GameConstants.get_all_cleaning_prospects_with_index() 
		|> Enum.find(fn({_skill, index}) -> String.to_integer(prospect_number) == index end)
		|> elem(0)
 
		{payment, customer_satisfaction} = get_cleaning_income(game_state, prospect)
        
        %{game_state | money: game_state.money + payment, reputation: game_state.reputation + customer_satisfaction }
	end


	defp get_cleaning_income(game_state, place) do

		current_person = List.first(game_state.staff)

    	person_skills = GameConstants.get_skills() 
    	|> Enum.map(fn(skill_name) -> current_person.skills[skill_name] end)
    	|> Enum.map(fn(skill_value) -> if !skill_value, do: 0, else: skill_value end)

    	wanted_skills = GameConstants.get_skills() 
    	|> Enum.map(fn(skill_name) -> place.needs[skill_name] end)
    	|> Enum.map(fn(skill_value) -> if !skill_value, do: 0, else: skill_value end)

    	customer_satisfaction = get_roi_value_of_skills(person_skills, wanted_skills)
    	
    	{ place.payment, customer_satisfaction }
  	end


	defp get_roi_value_of_skills(actual_skills, needed_skills) do
		sum = Enum.zip(actual_skills, needed_skills) 
		|> Enum.reduce(0, fn {actual, needed}, acc -> acc + 
			case actual - needed do
	      		x when x < 0 -> x
	      		x when x > 0.2 -> 0.1
	      		_ -> 0    
	  		end  
		end
		)     

		sum
	end

end
