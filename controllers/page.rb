class Page

  attr_reader :title
  attr_writer :title

  def initialize

  end

  def params=(params)
    @params = params
  end

  def request=(request)
    @request = request
  end

  def view

    pathstring = @request.path.to_s
    ext = File.extname(pathstring)

    if pathstring == "/"
      viewfile = "public/startpage"
    elsif
      paths = pathstring.split("/")
      paths.reverse!

      viewfile = nil

      paths.each do |path|

        if ext == ".tpl"
          path = path.gsub(".tpl","")
          ster = "views/templates/**/" + path + ".erb"
          viewio = Dir.glob(ster)
        else
          ster = "views/**/" + path + ".erb"
          viewio = Dir.glob(ster).reject{ |f| f['/templates/'] || f[%r{^/templates/}] }
        end

        if !viewio.empty?
          viewfile = viewio
          viewfile = viewfile.last.to_s
          viewfile = viewfile.gsub("views/", "")
          viewfile = viewfile.gsub(".erb", "")
          break
        end

      end

      if viewfile.nil?
        viewfile = "notfound"
      end

    end

    @view = viewfile

  end

  def slug
    parts = @request.path.split("/")
    @slug = parts.last
  end

  def template
    parts = @view.split("/")
    @template = parts.last
  end

  def pagetitle

    if @params[:page].to_s.empty?
      pathurl = @request.path
      pathurl = pathurl.gsub("/","")
      titlestring = (pathurl.empty?) ? "startpage" : pathurl
    else
      titlestring = (@params[:page]) ? @params[:page].to_s : "startpage"
    end

    case titlestring
    when "startpage"
      title = "Startpage"
    else
      title = titlestring.titleize
    end

    @pagetitle = title

  end

end