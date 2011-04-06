class Module
  def yaml_tag_read_class(name)
    name.sub!(/^YAML::Syck::/, 'Syck::')
    # Constantize the object so that ActiveSupport can attempt
    # its auto loading magic. Will raise LoadError if not successful.
    name.constantize
    name
  end
end