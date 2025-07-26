class ComponentGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('templates', __dir__)

  class_option :skip_spec, type: :boolean, default: false, desc: "Skip creating spec file"
  class_option :skip_preview, type: :boolean, default: false, desc: "Skip creating preview file"

  def create_component_file
    template "component.rb", "app/components/#{file_name}_component.rb"
    template "component.html.erb", "app/components/#{file_name}_component.html.erb"
  end

  def create_spec_file
    return if options[:skip_spec]
    template "component_spec.rb", "spec/components/#{file_name}_component_spec.rb"
  end

  def create_preview_file
    return if options[:skip_preview]
    template "component_preview.rb", "spec/components/previews/#{file_name}_component_preview.rb"
  end

  private

  def component_class_name
    "#{class_name}Component"
  end
end