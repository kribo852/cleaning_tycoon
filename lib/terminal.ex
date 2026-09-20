defmodule CleaningTycoon.Terminal do

	def start do
    	IO.puts Storage.welcome()
    	game_loop(nil)
  	end

  	def game_loop(tmp_frontend_memory) do 
  		{choices, new_tmp_frontend_memory} = Storage.get_menu_choices(tmp_frontend_memory)
  		game_info = Storage.get_data()
  		IO.puts game_info
  		IO.puts	"What do you want to do?"
  		IO.puts "Exit?"

  		selected = get_selected_choice_from_input(choices)

  		case selected do
  			:exit -> :exit
  				_ -> game_loop(Map.put(new_tmp_frontend_memory, :selected_action, selected))
  		end
  	end

  	
  	def get_selected_choice_from_input(choices) do
  		selected =  IO.gets((Enum.map(choices, fn x -> x.id <>" "<> x.text end) |> Enum.join(", "))  <> "\n\n") |> String.trim()

  		case selected do
  			"Exit" -> :exit
  			_ -> found = Enum.find(choices, fn x -> x.id == selected end)
  				 if Map.has_key?(found, :subchoices) do
  				 	selected <>"."<> get_selected_choice_from_input(found.subchoices)
  				 else
  				 	selected
  				 end
  		end
  	end

end
