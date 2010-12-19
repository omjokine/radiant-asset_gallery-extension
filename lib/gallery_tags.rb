module GalleryTags
  #tags available globally, not just on GalleryPages
  include Radiant::Taggable

  tag 'gallery' do |tag|
    tag.expand
  end

  # gallery:each
  #----------------------------------------------------------------------------
	desc "Iterate over all user's galleries."
  tag 'gallery:each' do |tag|
    attr = tag.attr.symbolize_keys
    result = []
    galleries = Gallery.find(:all)
    galleries.each do |gallery|
      tag.locals.gallery = gallery
      result << tag.expand
    end
    result
  end
    
  # gallery:name
  #----------------------------------------------------------------------------  
 	desc "Renders the HTML-escaped name of the current gallery."
  tag 'gallery:name' do |tag|
    gallery = tag.locals.gallery
    html_escape gallery.name ? gallery.name : "none"
  end

  # gallery:first_image
  #----------------------------------------------------------------------------
  desc "Retrieve the first image in the current gallery. Optionally takes 'size' attribute."
  tag 'gallery:first_image' do |tag|
	  attr = tag.attr.symbolize_keys
    gallery= tag.locals.gallery
    gallery_item = gallery.gallery_items.first
    item_title   = html_escape(gallery_item.asset.title ? gallery_item.asset.title : "")
    item_caption = html_escape(gallery_item.asset.caption ? gallery_item.asset.caption : "")
    %{<img src="#{gallery_item.first.asset.thumbnail(attr[:size])}" alt="#{item_title}" title="#{item_caption}" />}
  end

  # gallery:items
  #----------------------------------------------------------------------------
  desc "List thumbnails off all the items in a gallery. Optionally takes 'name'."
  tag 'gallery:items' do |tag|
    attr = tag.attr.symbolize_keys
    gallery = tag.locals.gallery || Gallery.find_by_name(attr[:name])
    result = []
    gallery_items = gallery.gallery_items
    gallery_items.each do |gallery_item|
      tag.locals.gallery_item = gallery_item
      result << tag.expand
    end
    result
  end

  tag 'gallery_item' do |tag|
    tag.expand
  end  

  # gallery_item:id  
  #----------------------------------------------------------------------------
  desc "Current gallery_item id"
  tag 'gallery_item:id' do |tag|
    gallery_item = tag.locals.gallery_item
    html_escape gallery_item.id ? gallery_item.id : "none"
  end

  # gallery_item:name  
  #----------------------------------------------------------------------------
  desc "Current gallery_item name"
  tag 'gallery_item:name' do |tag|
    gallery_item = tag.locals.gallery_item
    html_escape gallery_item.asset.title ? gallery_item.asset.title : ""
  end

  # gallery_item:caption
  #----------------------------------------------------------------------------
  desc "Current gallery_item caption"
  tag 'gallery_item:caption' do |tag|
    gallery_item = tag.locals.gallery_item
    html_escape gallery_item.asset.caption ? gallery_item.asset.caption : ""
  end

  # gallery_item:image  
  #----------------------------------------------------------------------------
  desc "Current gallery_item image optionally takes 'size' attribute"
  tag 'gallery_item:image' do |tag|
	  attr = tag.attr.symbolize_keys
    gallery_item = tag.locals.gallery_item
    item_title   = html_escape(gallery_item.asset.title ? gallery_item.asset.title : "")
    item_caption = html_escape(gallery_item.asset.caption ? gallery_item.asset.caption : "")
    unless attr[:size] == nil
      %{<img src="#{gallery_item.asset.thumbnail(attr[:size])}" alt="#{item_title}" title="#{item_caption}" />}
    else
      %{<img src="#{gallery_item.asset.thumbnail}" alt="#{item_title}" title="#{item_caption}" />}
    end
  end

  # gallery_item:image_url
  #----------------------------------------------------------------------------
  desc "Current gallery_item image url optionally takes 'size' attribute"
  tag 'gallery_item:image_url' do |tag|
	  attr = tag.attr.symbolize_keys
    gallery_item = tag.locals.gallery_item
    item_title   = html_escape(gallery_item.asset.title ? gallery_item.asset.title : "")
    item_caption = html_escape(gallery_item.asset.caption ? gallery_item.asset.caption : "")
    unless attr[:size] == nil
      %{"#{gallery_item.asset.thumbnail(attr[:size])}"}
    else
      %{"#{gallery_item.asset.thumbnail}"}
    end
  end
  
end
