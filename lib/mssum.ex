defmodule Mssum do
  # require IEx; IEx.pry
  @github_base_url Application.get_env(:app_vars, :githubBaseUrl)

  def main do
    user = "yothinix"
    repository = "mssum"

    make_request("/repos/#{user}/#{repository}/milestones")
    |> Poison.decode!
    |> Enum.at(-1)
    |> Map.get("url")
    |> String.replace(@github_base_url, "")
    |> IO.inspect

  end

  def make_request(endpoint \\ "/") do
    base_url = "#{@github_base_url}#{endpoint}"
    access_token = Application.get_env(:app_vars, :githubAccessToken)

    case HTTPoison.get(base_url, ["Authorization": "token #{access_token}"]) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        body
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        IO.puts "Not found :("
      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect reason
    end
  end
end
