class GithubData

  def query=(query)
    @query = query
  end    
  def get_users
    users = false

    if !@query.nil?

      http = Curl.get("https://api.github.com/search/users?q=" + @query) do|http|
        http.headers['Accept'] = "application/vnd.github.preview"
        http.headers['Authorization'] = "token " + GITHUB_OAUTH_TOKEN_CONST
      end
      result = JSON.parse(http.body_str)
      result.each do |array|
        if array[0] == 'items'
          users = array[1]
        end
      end
      
    end

    return users

  end
  
  def get_seconds_to_wait
    seconds_to_wait = 0

    http = Curl.get("https://api.github.com/rate_limit") do|http|
      http.headers['Accept'] = "application/vnd.github.preview"
      http.headers['Authorization'] = "token " + GITHUB_OAUTH_TOKEN_CONST
    end
    result = JSON.parse(http.body_str)
    search_limits = result["resources"]["search"]
    remaining = search_limits["remaining"]
    if(remaining == 0)
      seconds_to_wait = search_limits["reset"].to_i - Time.now.getutc.to_i
    end
      
    return seconds_to_wait

  end

end
