module AssetGallery
  module PaperclippedAssetModelExtension
    def self.included(base)
      base.class_eval {
        has_many  :gallery_items, :dependent => :destroy
      
        def self.quick_search(search="", items=nil)
          if !search.blank?
          
            search_cond_sql = []
            search_cond_sql << "LOWER(asset_file_name) LIKE (:term)"
            search_cond_sql << "LOWER(title) LIKE (:term)"
            search_cond_sql << "LOWER(caption) LIKE (:term)"
          
            cond_sql = "(#{ search_cond_sql.join(" or ") }) #{ 'AND assets.id NOT IN (:ids)' unless items.blank? }"

            @conditions = [cond_sql, {:term => "%#{search.downcase}%", :ids => items.map(&:asset_id)}]
          
          else
            unless items.blank?
              @conditions = ["id NOT IN (?)", items.map(&:asset_id)]
            end
          end

          options = { :conditions => @conditions,
                      :order => 'created_at DESC' }

          # ToDo: show only files from type image
          # @file_types = ["image"]
        
          Asset.find(:all, options)
        end
      }
      
    end
  end
end
