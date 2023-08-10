class MetaData
  attr_reader :webpage

  def initialize(url, webpage)
    @url = url
    @webpage = webpage
  end

  def collect_metadata
    {
      url: @url,
      num_links: num_links,
      images: images,
      last_fetch: last_fetch
    }
  end

  def num_links
    webpage.css('a').length
  end

  def images
    webpage.css('img').length
  end

  def last_fetch
    DateTime.now
  end
end
