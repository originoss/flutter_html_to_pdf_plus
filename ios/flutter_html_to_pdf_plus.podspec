#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'flutter_html_to_pdf_plus'
  s.version          = '0.0.1'
  s.summary          = 'A Flutter plugin for generating PDF documents from HTML code templates.'
  s.description      = <<-DESC
A Flutter plugin for generating PDF documents from HTML code templates
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Origin OSS' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'flutter_html_to_pdf_plus/Sources/flutter_html_to_pdf_plus/**/*'
  s.dependency 'Flutter'

  s.ios.deployment_target = '12.0'
end
