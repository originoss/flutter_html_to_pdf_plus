#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint flutter_html_to_pdf_plus.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'flutter_html_to_pdf_plus'
  s.version          = '0.0.1'
  s.summary          = 'Flutter HTML to PDF Plus plugin'
  s.description      = <<-DESC
A Flutter plugin to convert HTML to PDF with support for custom sizes.
                       DESC
  s.homepage         = 'https://github.com/originoss/flutter_html_to_pdf_plus'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Origin OSS' => 'theoriginoss@gmail.com' }
  s.source           = { :path => '.' }
  s.source_files     = 'flutter_html_to_pdf_plus/Sources/flutter_html_to_pdf_plus/**/*'
  s.dependency 'FlutterMacOS'

  s.platform = :osx, '10.14'
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }
  s.swift_version = '5.0'
end
