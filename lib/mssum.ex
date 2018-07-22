defmodule Mssum do
  # require IEx; IEx.pry
  @github_base_url Application.get_env(:app_vars, :githubBaseUrl)

  def main do
    user = "yothinix"
    repository = "mssum"

    get_latest_milestone(user, repository)
    |> get_issue_in_milestone(user, repository)
    |> IO.inspect

  end

  def get_issue_in_milestone(milestone, user, repo) do
    is_issue_in_milestone? = fn issue -> issue["milestone"]["number"] == milestone["number"] end

    get_all_issues(user, repo)
    |> Enum.filter(is_issue_in_milestone?)
  end

  def get_all_issues(user, repo) do
    make_request("/repos/#{user}/#{repo}/issues")
    |> Poison.decode!
  end

  def get_latest_milestone(user, repo) do
    make_request("/repos/#{user}/#{repo}/milestones")
    |> Poison.decode!
    |> Enum.at(-1)
    |> Map.get("url")
    |> String.replace(@github_base_url, "")
    |> make_request
    |> Poison.decode!
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
