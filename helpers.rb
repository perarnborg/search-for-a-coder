module ApplicationHelpers

  def is_view_public(viewfile=nil)
    return viewfile =~ /public|ajax/i
  end

  def is_view_ajax(viewfile=nil)
    return viewfile =~ /ajax/i
  end

  def is_session_loggedin
    session["loggedin"]
  end

  def request_headers
    env.inject({}){|acc, (k,v)| acc[$1.downcase] = v if k =~ /^http_(.*)/i; acc}
  end

  def humanize_string(textstring=nil)
    return Unicode::capitalize(textstring)
  end

  def get_base_url
    return "#{request.env['PATH_INFO']}"
  end

  def get_formatted_pagetitle
    pagetitle = "Search for a Coder"

    if(@Page.pagetitle == "Startpage")
      pagetitle
    elsif(@Page.pagetitle.nil?)
      pagetitle
    else
      @Page.title + " - " + pagetitle
    end
  end

  def find_template(views, name, engine, &block)
    Array(views).each { |v| super(v, name, engine, &block) }
  end

  def get_cachebuster_string
    if settings.show_debuginfo
      return "?" + settings.cachebuster_string
    end
  end

  def get_current_date
    d = Date.today
    return d.strftime("%B %d")
  end

end

helpers ApplicationHelpers

class String

  # Ruby has a capitalize method (used below) which capitalizes the
  #  first letter of a string.  But in order to capitalize the first
  #  letter of EVERY word we have to write our own.

  def titleize
    self.split(' ').collect {|word| word.capitalize}.join(" ")
  end

end

class Assets

  def JavaScript(asset=nil)
    filepath = settings.public_javascripts_path + asset
    filepath += (settings.show_debuginfo) ? "?" + settings.cachebuster_string : ""
    return '<script src="'+filepath+'"></script>'
  end

  def Stylesheet(asset=nil)
    filepath = settings.public_stylesheets_path + asset
    filepath += (settings.show_debuginfo) ? "?" + settings.cachebuster_string : ""
    return '<link href="'+filepath+'" rel="stylesheet" media="screen" />'
  end

end

