class Ajax

  def params=(params)
    @params = params
  end

  def get_data
    type = (!@params[:type].nil?) ? @params[:type] : nil
    data = nil

    if !type.nil?
      case type
        when "item"
          result = Array.new
          items = Item.all
          items.each do |item|
            grouped = { "item" => item }
            result.push(grouped)
          end
          data = result
        when "users"          
          users = Array.new
          query = (!@params[:q].nil?) ? @params[:q] : nil
          if !query.nil?
            @GithubData = GithubData.new
            @GithubData.query = query
            users = @GithubData.get_users
          end
          data = users
        else
          data = nil
      end

    end

    return data

  end

  def get_seconds_to_wait
    seconds = 0
    @GithubData = GithubData.new
    seconds = @GithubData.get_seconds_to_wait

    return seconds

  end

end
