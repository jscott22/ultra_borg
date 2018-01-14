defmodule UltraBorg.Sensors do

  use Bitwise

  alias UltraBorg.I2C

  @sensors %{
    usm1: 1,
    usm2: 2,
    usm3: 3,
    usm4: 4
  }

  @usm_us_to_mm 0.171500

  def read_sensors() do
    Enum.into(@sensors, %{}, fn {k, v} -> 
      {k, read_sensor(v)}
    end)
  end

  defp read_sensor(sensor_id) do
    I2C.read(sensor_id)
    |> :binary.bin_to_list()
    |> Enum.take(3)
    |> translate_reading()
  end

  def translate_reading([_sensor_id, r1, r2]) do
    time_us = (r1 <<< 8) + r2

    time_us = 
    case time_us == 65535 do
      true -> 0
      false -> time_us
    end

    time_us * @usm_us_to_mm
  end
end