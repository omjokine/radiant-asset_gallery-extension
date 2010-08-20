class Admin::GalleryItemsController < ApplicationController
  
  # add an item to the gallery
  def create
    asset_id = (params[:gallery_item][:asset_id]).gsub("gallery_item_", "")
    gallery  = Gallery.find(params[:gallery_id])
    unless gallery.gallery_items.exists?(:asset_id => asset_id)
      gallery.gallery_items.create(:asset_id => asset_id)
    end
    respond_to do |format|
      format.html { render :nothing => true }
      format.js   {
        render :update, :status => 200 do |page|
          page << 'Asset.SortItems();'
        end
      }
    end
  end
  
  # remove an item from the gallery
  def destroy
    asset_id = params[:id].gsub("gallery_item_", "")
    item = GalleryItem.find_by_gallery_id_and_asset_id(params[:gallery_id], asset_id)
    item.destroy
    respond_to do |format|
      format.html { render :nothing => true }
      format.js   {
        gallery = Gallery.find(params[:gallery_id])
        items   = gallery.gallery_items # remove items from assets view!
        @assets = Asset.quick_search('', items)
        render :update, :status => 200 do |page|
          page.replace_html "asset_items", :partial => 'admin/galleries/assets.html.haml', :locals => { :assets => @assets }
          page << 'Asset.MakeDraggables();'
        end
      }
    end
  end

  # sort gallery items
  def sort
    gallery = Gallery.find(params[:gallery_id])
    items = CGI::parse(params[:items])['gallery_items[]']
    items.each_with_index do |id, index|
      gallery.gallery_items.update_all(['position=?', index+1], ['asset_id=?', id])
    end
    respond_to do |format|
      format.html { render :nothing => true }
      format.js   { render :nothing => true, :status => 200 }
    end
  end
  
end