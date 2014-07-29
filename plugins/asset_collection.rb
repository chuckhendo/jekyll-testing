# Asset Collection Jekyll Plugin
#
# Built by Carl Henderson (@chuckhendo)

module Jekyll
  
  class AssetCollectionGenerator < Generator
    safe true
    priority :highest

    def generate(site)
      collection = [] 
      Dir[File.join(site.source, 'fp-images', "/*")].each do |pf|
        pf = pf.sub(/\A#{site.source}\//, '')
        collection << pf
      end
      collection.sort!
      site.data['fp-images'] = collection
    end

  end  

end
