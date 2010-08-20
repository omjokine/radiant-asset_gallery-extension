module AssetGallery
  module GlobalizedAssetModelExtension
    def self.included(base)
      base.class_eval {
        has_many  :gallery_items, :dependent => :destroy
      
        def self.quick_search(search="", items=nil)
          if !search.blank?
          
            search_cond_sql = []
            search_cond_sql << "LOWER(assets.asset_file_name) LIKE (:term)"
            search_cond_sql << "LOWER(asset_translations.title) LIKE (:term)"
            search_cond_sql << "LOWER(asset_translations.caption) LIKE (:term)"
          
            cond_sql = "(#{ search_cond_sql.join(" or ") }) AND asset_translations.locale = (:locale) #{ 'AND assets.id NOT IN (:ids)' unless items.blank? }"

            @conditions = [cond_sql, {:term => "%#{search.downcase}%", :locale => I18n.locale.to_s, :ids => items.map(&:asset_id)}]
          
          else
            unless items.blank?
              @conditions = ["asset_translations.locale = ? AND assets.id NOT IN (?)", I18n.locale.to_s, items.map(&:asset_id)]
            else
              @conditions = ["asset_translations.locale = ?", I18n.locale.to_s]
            end
          end
          
          options = { :conditions => @conditions,
                      :joins => "INNER JOIN asset_translations ON asset_translations.asset_id = assets.id",
                      :order => 'created_at DESC' }

          # ToDo: show only files from type image
          # @file_types = ["image"]
        
          Asset.find(:all, options)
        end
      }
      
    end
  end
end
