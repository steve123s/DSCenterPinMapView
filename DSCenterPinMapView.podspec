Pod::Spec.new do |s|

# Pod Information
s.platform = :ios
s.ios.deployment_target = '11.0'
s.name = "DSCenterPinMapView"
s.summary = "DSCenterPinMapView makes it easy for you to use a MKMapView with a central and animated pin to get locations."
s.requires_arc = true

# Versioning
s.version = "0.1.0"

# License
s.license = { :type => "MIT", :file => "LICENSE" }

# Author
s.author = { "Daniel Esteban Salinas" => "danielesalinas23@gmail.com" }

# Pod Github URL
s.homepage = "https://github.com/steve123s/DSCenterPinMapView"

# Source
s.source = { :git => "https://github.com/steve123s/DSCenterPinMapView.git",
             :tag => "#{s.version}" }

# Framework and Dependencies (Other Pods)
s.frameworks = "UIKit", "MapKit"

# Source Files
s.source_files = "DSCenterPinMapView/**/*.{swift}"

# Resources
s.resources = "DSCenterPinMapView/**/*.{png,jpeg,jpg,storyboard,xib,xcassets}"

# Swift Version
s.swift_version = "5"

end
