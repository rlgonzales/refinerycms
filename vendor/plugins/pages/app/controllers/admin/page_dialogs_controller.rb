class Admin::PageDialogsController < Admin::DialogsController

  require 'net/http'
  
  crudify :page

  def link_to
    @pages = Page.paginate :page => params[:page],
                             :conditions => 'parent_id is null',
                             :order => 'position ASC',
                             :per_page => Page.per_page(dialog=true)

		@resources = Resource.paginate :page => params[:resource_page], :order => 'created_at DESC', :per_page => Resource.per_page(dialog=true)
  end
  
  def test_url
    unless params[:url].blank?
      url = URI.parse(params[:url])

      http = Net::HTTP.new(url.host)
      request = Net::HTTP::Get.new(url.path.blank? ? "/" : url.path)
      
      response = http.request request
    
      render :text => case response
        when Net::HTTPSuccess, Net::HTTPRedirection
          "<img src='/images/refinery/icons/tick.png' alt='valid url' title='valid url' width='16' height='16' />"
        else
          "<img src='/images/refinery/icons/cross.png' alt='invalid url' title='invalid url' width='16' height='16' />"
        end
    end
    
    rescue 
      render :text => "<img src='/images/refinery/icons/cross.png' alt='invalid url' title='invalid url' width='16' height='16' />"
  end
  
  def test_email
    unless params[:email].blank?
      valid = params[:email] =~ /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i
      render :text => if valid
        "<img src='/images/refinery/icons/tick.png' alt='valid email address' title='valid email address' width='16' height='16' />"
      else
        "<img src='/images/refinery/icons/cross.png' alt='invalid email address' title='invalid email address' width='16' height='16' />"
      end
    end
  end
  
end