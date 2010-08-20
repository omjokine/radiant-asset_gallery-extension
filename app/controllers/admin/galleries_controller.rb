class Admin::GalleriesController < ApplicationController

  def index
    @galleries = Gallery.find(:all, :order => "name")
  end

  def new
    @gallery = Gallery.new
  end

  def edit
    @gallery = Gallery.find(params[:id])
    if @gallery
      @items  = @gallery.gallery_items
      @assets = Asset.quick_search("",@items)
      render(:action => 'edit')
    else
      redirect_to(admin_gallery_path)
    end
  end

  def create
    params[:gallery][:user_id] = current_user.id
    @gallery = Gallery.new(params[:gallery])
    if @gallery.save
      flash[:notice] = "Successfully added a new gallery."
      redirect_to(edit_admin_gallery_path(@gallery.id))
    else
      flash[:error] = "Validation errors occurred while processing this form. Please take a moment to review the form and correct any input errors before continuing."
      render(:action => 'edit')
    end
  end

  def update
    @gallery = Gallery.find(params[:id])
    if @gallery.update_attributes(params[:gallery])
      flash[:notice] = "Successfully updated the gallery details."
      redirect_to(admin_galleries_path)
    else
      flash[:error] = "Validation errors occurred while processing this form. Please take a moment to review the form and correct any input errors before continuing."
      render(:action => 'edit')
    end
  end


  def destroy
    @gallery = Gallery.find(params[:id])
    @gallery.destroy
    flash[:error] = "The gallery was deleted."
    redirect_to(admin_galleries_path)
  end

  # search assets
  def search
    gallery = Gallery.find(params[:id])
    items   = gallery.gallery_items # remove items from assets view!
    @assets = Asset.quick_search(params[:search], items)
    respond_to do |format|
      format.html { render :layout => false }
      format.js {
        render :update do |page|
          page.replace_html "asset_items", :partial => 'admin/galleries/assets.html.haml', :locals => { :assets => @assets }
          page << 'Asset.MakeDraggables();'
        end
      }
    end
  end
  
end
