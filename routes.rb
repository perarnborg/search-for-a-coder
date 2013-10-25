### FILTERS

# CATCH ALL
before do

  @Assets = Assets.new
  @Page = Page.new

  @Params = params
  @Request = request

  @Page.params = @Params
  @Page.request = @Request
  @Page.title = @Page.pagetitle

  @View = @Page.view

  @Publicview = is_view_public(@View)
  @Ajaxview = is_view_ajax(@View)

#  if request.xhr?
    @Ajax = Ajax.new
    @Ajax.params = @Params
#  end

end

before "/github_users" do
  @Data = @Ajax.get_data
end
before "/github_limits" do
  @Data = @Ajax.get_seconds_to_wait
end

### ROUTES

# STARTPAGE
get "/" do
  erb @View.to_sym, :layout => :app
end

# SASS
get "/stylesheets/:name.css" do

  content_type "text/css", :charset => "utf-8"
  if !settings.show_debuginfo
    response["Expires"] = (Time.now + 60*60*24*356*3).httpdate
  end
  scss(:"stylesheets/#{params[:name]}", Compass.sass_engine_options)

end

# CATCH ALL
get "/:page/?*" do

  if params[:format] == "json"
    response.headers['Content-Type'] = "application/json"
  end

#  if request.xhr?
  if @Ajaxview
    layout = "ajax"
  else
    layout = "app"
  end

  if !@View.nil?
    # View found
    if @View != "notfound"
      # All is fine - render view
      erb @View.to_sym, :layout => layout.to_sym
    else
      # View isn't there - render 404
      raise error(404)
    end
  else
    # View isn't set - render 404
    raise error(404)
  end

end

# NOT FOUND (404)
not_found do
  @Page.title = "Not found"
  erb :"common/notfound", :layout => :app
end
