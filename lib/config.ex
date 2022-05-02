defmodule ExUrlbox.Config do
  @moduledoc """
  Retrieve config variables that are used with Urlbox's API.

  All settings also accept `{:system, "ENV_VAR_NAME"}` to read their
  values from environment variables at runtime.

  """

  # Config pattern inspired from https://github.com/danielberkompas/ex_twilio

  @doc """
  Returns the *URLBOX_API_KEY*
      config :ex_urlbox, api_key: "URLBOX_API_KEY"
  """
  def api_key, do: from_env(:ex_urlbox, :api_key)

  @doc """
  Returns the *URLBOX_API_SECRET*
      config :ex_urlbox, api_secret: "URLBOX_API_SECRET"
  """
  def api_secret, do: from_env(:ex_urlbox, :api_secret)

  @doc """
  Returns the default api endpoint
  """
  def api_endpoint, do: "https://api.urlbox.io/v1/" <> api_key()


  @doc """
  A light wrapper around `Application.get_env/2`, providing automatic support for
  `{:system, "VAR"}` tuples.
  """
  def from_env(otp_app, key, default \\ nil)

  def from_env(otp_app, key, default) do
    otp_app
    |> Application.get_env(key, default)
    |> read_from_system(default)
  end

  defp read_from_system({:system, env}, default), do: System.get_env(env) || default
  defp read_from_system(value, _default), do: value
end
