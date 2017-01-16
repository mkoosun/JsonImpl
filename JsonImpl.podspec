Pod::Spec.new do |s|
  s.name             = 'JsonImpl'
  s.version          = '1.0.0'
  s.summary          = 'A short description of JsonImpl.'

  s.description      = <<-DESC
                       Convenient and Simple Data Modeling Framework for JSON - Very useful for network protocol，and support inheritance, nesting.
                       DESC

  s.homepage         = 'https://github.com/mkoosun/JsonImpl'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'mkoo.sun' => 'mkoosun@gmail.com' }
  s.source           = { :git => 'https://github.com/mkoosun/JsonImpl.git', :tag => s.version.to_s }


  s.ios.deployment_target = '6.0'

  s.source_files = 'JsonImpl/Classes/**/*'
  
end
