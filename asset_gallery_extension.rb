class AssetGalleryExtension < Radiant::Extension
  version "1.1"
  description "Create galleries with images uploaded by paperclipped_extension"
  url "http://github.com/jfqd/radiant-asset_gallery-extension"
  
  define_routes do |map|
    map.namespace :admin, :member => { :remove => :get, :search => :get } do |admin|
      admin.resources :galleries
      
      admin.resources :galleries do |gallery|
        gallery.items_sort 'items/sort.:format', :controller => 'gallery_items', :action => 'sort', :conditions => { :method => :put }
        gallery.resources :items, :controller => 'gallery_items', :only => [ :create, :destroy ]
      end
      
    end
  end
  
  def activate
    tab 'Content' do
      add_item 'Gallery', '/admin/galleries', :after => 'Assets'
    end

    Page.send :include, GalleryTags
    User.send :include, AssetGallery::UserModelExtension
    
    # compatibility with globalize2_paperclipped
    if defined?(Globalize2PaperclippedExtension)
      Asset.send :include, AssetGallery::GlobalizedAssetModelExtension
    else
      Asset.send :include, AssetGallery::PaperclippedAssetModelExtension
    end
    
  end
end
