
  Pod::Spec.new do |s|
    s.name = 'CapacitorGeofencing'
    s.version = '0.0.1'
    s.summary = 'Easy interface to register GeoFences on iOS.'
    s.license = 'MIT'
    s.homepage = 'https://github.com/JillevdW/Capacitor-Geofencing.git'
    s.author = 'Jille van der Weerd'
    s.source = { :git => 'https://github.com/JillevdW/Capacitor-Geofencing.git', :tag => s.version.to_s }
    s.source_files = 'ios/Plugin/Plugin/**/*.{swift,h,m,c,cc,mm,cpp}'
    s.ios.deployment_target  = '11.0'
    s.dependency 'Capacitor'
  end