require 'optparse'

module S3find
  class Application

    def run
        options = {}
        parser = OptionParser.new do |opt|
        opt.banner = ""
        opt.separator "s3find - a find for S3 public buckets."
        opt.separator ""
        opt.separator "Usage:"
        opt.separator " s3find <bucket> [OPTIONS]"
        opt.separator ""
        opt.separator "   <bucket>   bucket_name or full URI ( http://bucket_name.s3.amazonaws.com )"
        opt.separator ""
        opt.separator "Options:"

        opt.on('-n', '--name=pattern'   , 'filters names by pattern') { |pattern| options[:name] = pattern }
        opt.on('-i', '--iname=pattern'  , 'case insensitive -n') { |pattern| options[:iname] = pattern }
        opt.on('-s', '--sort=field'     , 'sort by name | size | date') do |field| 
          abort("Invalid field for sort: #{field}. Should be one of  name | size | date.") unless %w(name size date).include? field
          options[:sort] = {name: :key, size: :size, date: :modified}[field.to_sym] 
        end
        opt.on('-r', '--rsort=field'    , 'reverse sort (descending)') do |field| 
          abort("Invalid field for sort: #{field}. Should be one of  name | size | date.") unless %w(name size date).include? field
          options[:sort] = {name: :key, size: :size, date: :modified}[field.to_sym]
          options[:reverse] = true
        end
        opt.on('-l', '--limit=num'  , 'items to display') {|num| options[:limit] = num.to_i }
        opt.separator ""
        opt.on('-h', '--help'       , 'displays help') { puts opt; exit }
        opt.on('-v', '--version'    , 'displays version') { puts S3find::VERSION; exit }
        opt.separator ""
        end

        begin
          parser.parse!
        rescue OptionParser::InvalidOption, OptionParser::MissingArgument 
          abort "#{$!.to_s.capitalize}\n"                                                           
        end 

        resource  = ARGV[0]
        abort "Can't go ahead without a <bucket>" if resource.nil?

        s3 = Base.new(resource)
        if (results = s3.find(options))
          results.each{ |r|  puts r.to_s }
          puts "[#{results.count}/#{s3.items.count}]"
        else
          puts "no results"      
        end

        # if command == 'get'
        #   landregistry.get(filename)
        #   puts 'done!'
        # end

    end
  end  
end

