module Feedbook
  class PluginsManager

    # Loads plugins and extensions from given path.
    # @param path [String] plugins directory path
    # 
    # @return [NilClass] nil
    def self.load_plugins(path)
      print "Loading plugins from #{path}... "
      if File.directory? path
        Dir[File.join(path, '**', '*.rb')].sort.each do |f|
          require f
        end
        puts 'completed.'
      else
        puts "Plugins directory could not be found in #{path}."
      end
    end
  end
end
