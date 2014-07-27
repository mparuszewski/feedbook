module Feedbook
  class PluginsManager

    # Loads plugins and extensions from given path.
    # @param path [String] plugins directory path
    # 
    # @return [NilClass] nil
    def self.load_plugins(path)
      if File.directory? path
        Dir[File.join(path, '**', '*.rb')].sort.each do |f|
          require f
        end
      else
        print "Plugins directory could not be found in #{path}."
      end
    end
  end
end
