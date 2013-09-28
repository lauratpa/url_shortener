class UrlsController < ApplicationController
  def new
    @url = Url.new
  end

  def create
    @url = Url.new(url_params)
    if @url.save
      flash[:notice] = root_url+ @url.id.to_s(32)
    else
      flash[:error] = "Invalid url"
    end
    redirect_to root_path
  end

  def show
    last_char = params[:id][-1]

    case last_char
    when '!' then show_link(params[:id][0...-1])
    when '+' then show_link_stats(params[:id][0...-1])
    else redirect_to_url(params[:id])
    end
  end

  private
    def url_params
      params.require(:url).permit(:url)
    end

    def show_link(id)
      show_url(id) do |url|
        @url = url
        render 'show_link'
      end
    end

    def show_link_stats(id)
      show_url(id) do |url|
        @url = url
        render 'show_link_stats'
      end
    end

    def redirect_to_url(id)
      show_url(id) do |url|
        url.visits +=1
        url.save
        redirect_to url.url
      end
    end

    def show_url(id)
      id = id.to_i(32)
      url = Url.find_by_id(id)
      if id != 0 && url
        yield ( url )
      else
        redirect_to root_path
      end
    end
end
