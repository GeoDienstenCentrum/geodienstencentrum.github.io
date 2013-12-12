# Jekyll Generator for tag index pages.
#
# see http://charliepark.org/tags-in-jekyll/

module Jekyll
  
  # creates the page for a tag.
  class TagIndex < Page
    
    def initialize(site, base, dir, tag)
      @site = site
      @base = base
      @dir = dir
      @name = 'index.html'

      self.process(@name)
      self.read_yaml(File.join(base, '_layouts'), 'tag_index.html')
      self.data['tag'] = tag
      self.data['title'] = "Pagina's met het trefwoord &ldquo;"+tag+"&rdquo;"
    end
    
  end

  # creates the tag index.
  class TagGenerator < Generator
    safe true

    def generate(site)
      if site.layouts.key? 'tag_index'
        dir = 'tag'
        site.tags.keys.each do |tag|
          write_tag_index(site, File.join(dir, tag), tag)
        end
      end
    end

    def write_tag_index(site, dir, tag)
      index = TagIndex.new(site, site.source, dir, tag)
      index.render(site.layouts, site.site_payload)
      index.write(site.dest)
      # index.write(site.source)
      site.pages << index
    end

  end

end