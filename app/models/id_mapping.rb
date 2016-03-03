class IdMapping
  attr_reader :mappings

  def initialize(mention_mappings_yaml)
    if mention_mappings_yaml =~ /\Ahttp(:?s)?/
      require 'open-uri'
      yaml_content = open(mention_mappings_yaml)
      @mappings = YAML.load(yaml_content)
    else
      @mappings = YAML.load_file(mention_mappings_yaml)
    end
  end

  def find(user_name:, from:, to:)
    user = @mappings.detect { |u| u[from.to_s] == user_name.to_s }
    user[to].to_s
  rescue
    nil
  end
end
