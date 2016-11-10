 
Pod::Spec.new do |s|
 

  s.name         = "MonkeyMapSearch"
  s.version      = "1.2"
  s.summary      = "MonkeyMapSearch Sample Task....."
 

  s.homepage     = "https://github.com/junhaiyang/MonkeyMapSearch"
 
  s.license      = "MIT"
 
  s.author             = { "yangjunhai" => "junhaiyang@gmail.com" } 
  s.ios.deployment_target = "7.0" 

  s.ios.framework = 'UIKit'
 
  s.source = { :git => 'https://github.com/junhaiyang/MonkeyMapSearch.git' , :tag => '1.2'} 
 
  s.requires_arc = true

  s.source_files = 'MonkeyMapSearch/*.{h,m,mm}'  


  s.subspec 'operation' do |ds|
    
    ds.source_files = 'MonkeyMapSearch/operation/*.{h,m,mm}' 
          
  end
   
  s.compiler_flags = '-w'
   
  s.dependency 'MonkeyMapConfig'
 
end
