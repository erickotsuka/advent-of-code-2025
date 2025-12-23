initial_value = {50, 0}
max_safe_value = 99

password_calculator_1 = fn item, acc ->
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

password_calculator_2 = fn item, acc ->
  {direction, value_as_text} = String.split_at(item, 1)
  value_as_int = String.trim(value_as_text) |> String.to_integer()

  {previous_value, total_zeros} = acc

  total_full_rotations = div(value_as_int, max_safe_value + 1)
  not_full_rotation_amount = rem(value_as_int, max_safe_value + 1)

  {next_value, passes_zero} =
    case direction do
      "L" ->
        if previous_value - not_full_rotation_amount < 0 do
          {max_safe_value + 1 - (not_full_rotation_amount - previous_value), previous_value != 0}
        else
          {previous_value - not_full_rotation_amount, false}
        end

      "R" ->
        {rem(previous_value + value_as_int, max_safe_value + 1),
         previous_value + not_full_rotation_amount > max_safe_value + 1}

      _ ->
        IO.puts("Not L nor R")
    end

  {next_value,
   if next_value == 0 or passes_zero do
     total_zeros + 1 + total_full_rotations
   else
     total_zeros + total_full_rotations
   end}
end

input = File.read!("../inputs/01.txt")

{_, password} =
  String.trim(input) |> String.split("\n") |> Enum.reduce(initial_value, password_calculator_2)

IO.puts(password)
