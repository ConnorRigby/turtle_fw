defmodule TurtleFw.Socket do
  use PhoenixChannelClient.Socket, otp_app: :turtle_fw

  def configure(nil), do: configure([])

  def configure(user_config) when is_list(user_config) do
    default_config = []

    config = Keyword.merge(default_config, user_config)
    Application.put_env(:turtle_fw, __MODULE__, config)
  end
end