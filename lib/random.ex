defmodule CleaningTycoon.Random do

	#Used in order to get random values, that stay the same during one day but shifts to the next day. 
	#This is so that the same lists, of prospects and employees can be accessed multiple times.
	def get_random_value_per_day(%{actual_for_day: actual_for_day, value: value}, day_counter) do 
	  if actual_for_day == day_counter do 
	    %{actual_for_day: actual_for_day, value: value}
	  else
	    %{actual_for_day: day_counter, value: :rand.uniform(10**10)}
	  end
	end

end