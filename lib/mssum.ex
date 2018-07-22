defmodule Mssum do
  # require IEx; IEx.pry
  def main do
    user = "yothinix"
    repository = "mssum"

    make_request("/repos/#{user}/#{repository}/milestones") |> list_milestone

  end

  def list_milestone(milestones) do
    Enum.map(milestones, fn milestone -> IO.puts milestone["url"] end)
  end

  def make_request(endpoint \\ "/") do
    base_url = "https://api.github.com#{endpoint}"
    access_token = Application.get_env(:app_vars, :github_access_token)

    case HTTPoison.get(base_url, ["Authorization": "token #{access_token}"]) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        body |> Poison.decode!
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        IO.puts "Not found :("
      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect reason
    end
  end
end
