# Project Jekyll Plugin
#
# Built by Carl Henderson (@chuckhendo)
# Based on jekyll-postfiles at https://github.com/indirect/jekyll-postfiles/

module Jekyll
  require 'fastimage'
  
  # # StaticFile subclass that properly translates paths
  class ProjectFile < StaticFile
    def destination(dest)
      
      File.join(*[dest, @dir[2..-1], @name].compact)
    end

    def relative_path
      path.sub(/\A#{@site.source}\/_/, '/')
    end
  end



  class ProjectDocument < Document
    def read_project_assets(pf)
      
      base_path = pf.sub(/\A#{@site.source}/, '')
      Dir[File.join(pf, "/*")].each do |f|
        f_base = File.basename(f)
        if f_base =~ /^featured\..*/
          featured_image = Jekyll::ProjectFile.new(@site, @site.source, base_path, f_base)
          @data["featured_image"] = featured_image.relative_path
          site.static_files << featured_image
        elsif f_base =~ /^thumb\..*/
          thumbnail = Jekyll::ProjectFile.new(@site, @site.source, base_path, f_base)
          @data["thumbnail"] = thumbnail.relative_path
          site.static_files << thumbnail
        elsif f_base != "index.md"
          project_image = Jekyll::ProjectFile.new(@site, @site.source, base_path, f_base)
          if !@data["project_images"]
            @data["project_images"] = []
          end
          image_size = FastImage.size(project_image.path)
          @data["project_images"] << { "src" => project_image.relative_path, "width" => image_size[0], "height" => image_size[1] }
          puts @data["project_images"].inspect
          site.static_files << project_image
        end
        
      end

      @data["project_images"].sort_by! { |hsh| hsh[:src] } unless not @data["project_images"]
    end
  end


  class ProjectCollection < Collection
    def read
      Dir[File.join(directory, "/*")].each do |pf|
        if File.directory?(pf)
          doc = Jekyll::ProjectDocument.new(Jekyll.sanitized_path(directory, File.join(pf, 'index.md')), { site: site, collection: self })
          doc.read
          doc.read_project_assets(pf)
          docs << doc
        end
      end
      docs.sort!
    end


    def write?
      true
    end

    def url_template
      metadata.fetch('permalink', "/:collection/:path:output_ext")
    end

  end

  class Postfiles < Generator
    safe true
    priority :highest

    def generate(site)
      puts "GENERATING!!!!!!"
      collection = Jekyll::ProjectCollection.new(site, "projects")
      collection.read
      site.collections["projects"] = collection
  
    end

  end

  # class PostfileTag < Liquid::Tag

  #   def initialize(tag_name, text, tokens)
  #     super
  #     @text = text.strip
  #   end

  #   def render(context)
  #     File.join(context['page']['url'], @text)
  #   end
  # end

  

end


# Liquid::Template.register_tag('postfile', Jekyll::PostfileTag)