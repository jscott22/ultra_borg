defmodule UltraBorg.Detection do

  alias UltraBorg.I2C
  
  @command_get_id               0x99
  @i2c_max_len                  6
  
  def find_borg(i2c_address) do
    recv = I2C.read(@command_get_id)
    |> IO.inspect()
    |> :binary.bin_to_list()
    
    handle_found_device(recv, i2c_address, length(recv) == @i2c_max_len)
  end

  def handle_found_device(recv, i2c_address, true) do
    case Enum.at(recv, 1) == i2c_address do
      true ->
        IO.puts("Found UltraBorg at #{i2c_address}")
        true
      false ->
        IO.puts("Found a device at #{i2c_address}, but it is not a UltraBorg")
        false
    end
  end

  def handle_found_device(_recv, i2c_address, false) do
    IO.puts("Missing UltraBorg at #{i2c_address}")
    false
  end

end