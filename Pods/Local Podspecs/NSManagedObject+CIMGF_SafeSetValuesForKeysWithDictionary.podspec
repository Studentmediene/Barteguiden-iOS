Pod::Spec.new do |s|
  s.name         = "NSManagedObject+CIMGF_SafeSetValuesForKeysWithDictionary"
  s.version      = "0.0.1"
  s.summary      = "A safe version to set values from a dictionary."
  s.homepage     = "https://github.com/skohorn/NSManagedObject-CIMGF_SafeSetValuesForKeysWithDictionary"
  s.author       = 'Tom Harrington', 'original author'
  s.source       = {
    :git => "https://github.com/skohorn/NSManagedObject-CIMGF_SafeSetValuesForKeysWithDictionary.git",
    :tag => "0.0.1"
  }
  s.platform     = :ios, '4.0'
  s.source_files = '*.{h,m}'
  s.requires_arc = true
end
