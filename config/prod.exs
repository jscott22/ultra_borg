use Mix.Config

import Supervisor.Spec, warn: false

config :ultra_borg,
  i2c: ElixirALE.I2C