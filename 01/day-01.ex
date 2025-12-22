initial_value = {50, 0}
max_safe_value = 99

password_calculator = fn item, acc ->
  {direction, value_as_text} = String.split_at(item, 1)
  value_as_int = String.trim(value_as_text) |> String.to_integer()

  {previous_value, total_zeros} = acc

  next_value =
    case direction do
      "L" ->
        if previous_value - rem(value_as_int, max_safe_value + 1) < 0 do
          max_safe_value + 1 - (rem(value_as_int, max_safe_value + 1) - previous_value)
        else
          previous_value - rem(value_as_int, max_safe_value + 1)
        end

      "R" ->
        rem(previous_value + value_as_int, max_safe_value + 1)

      _ ->
        IO.puts("Not L nor R")
    end

  {next_value,
   if next_value == 0 do
     total_zeros + 1
   else
     total_zeros
   end}
end

input = File.read!("../inputs/01.txt")

{_, password} =
  String.trim(input) |> String.split("\n") |> Enum.reduce(initial_value, password_calculator)

IO.puts(password)
