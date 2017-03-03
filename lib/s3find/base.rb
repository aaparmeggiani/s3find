require 'open-uri'
require 'nokogiri'
require 'active_support/core_ext/hash'

module S3find
  class Base
    attr_reader :items

    def initialize(resource)
      @items = []
      fetch(resource)
    end

    def fetch(resource)
      doc = Nokogiri::XML(open(resource))
      contents = Hash.from_xml(doc.to_xml)['ListBucketResult']['Contents']
      contents.each{ |c| @items << Item.new(
          key:      c['Key'],
          size:     c['Size'],
          modified: c['LastModified'],
          etag:     c['ETag'])
      }
    rescue
      puts "Error: #{$!}"
    end

    def find(options = {})
      return @items if @items.empty? || options.empty?
      r = @items
      r = r.select { |r| r.key.include?(options[:name]) } if options[:name]
      r = r.select { |r| r.key.downcase.include?(options[:iname]) } if options[:iname]
      r = r.sort_by{ |r| r.send(options[:sort])} if options[:sort]
      r = r.reverse if options[:reverse]
      r = r.first(options[:limit]) if options[:limit]
      r
    end

    def count(result)
      dirs = files = bytes = 0
      result.each do |r|
        dirs  += 1       if r.size == 0
        files += 1       if r.size > 0
        bytes += r.size  if r.size > 0
      end  
      { dirs: dirs, files: files, bytes: bytes }
    end

    # def get(filename)
    #   download = open(END_POINT + filename)
    #   IO.copy_stream(download,  "./Downloads/#{download.base_uri.to_s.split('/')[-1]}")
    # end

  end
end