defmodule Employee do
	defstruct name: "Molly Manager", skills: %{vacuuming: 0.3, mopping: 0.3}, can_fire: false, speed: 1.0, mood: 0.5, stress: 0.5 
end

defimpl String.Chars, for: Employee do
  def to_string(employee) do

    "#{employee.name}  #{employee.skills |> Enum.map(fn {key, value} -> "#{key}: #{value}" end) |> Enum.join(" ")}"
  end
end
