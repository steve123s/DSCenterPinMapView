//
//  DSCenterPinMapView.swift
//  steve123s
//
//  Created by Daniel Esteban Salinas on 03/08/20.
//  Copyright © 2020 com.inventivetech. All rights reserved.
//

import UIKit
import MapKit

public protocol DSCenterPinMapViewDelegate {
    /// This method is called when user begind dragging the map
    func didStartDragging()
    
    /// This method is called when the user ends dragging the map
    func didEndDragging()
}

public class DSCenterPinMapView: UIView {
    
    //------------------------------------
    // MARK: - Public Properties
    //------------------------------------
    
    /// Center pin and shadow reference
    public var pin: DSCenterPinView = DSCenterPinView()
    
    /// MKMapView reference
    public var mapview: MKMapView = MKMapView()
    
    /// Center Pin's Pin image view offset to adjust custom assets X Position
    public var pinOffsetX: CGFloat = 0 {
        didSet {
            updateFrames(animated: false)
        }
    }
    
    /// Center Pin's Pin image view offset to adjust custom assets Y Position
    public var pinOffsetY: CGFloat = 0 {
        didSet {
            updateFrames(animated: false)
        }
    }
    
    /// Center Pin's Shadow image view offset to adjust custom assets X Position
    public var shadowOffsetX: CGFloat = 0 {
        didSet {
            updateFrames(animated: false)
        }
    }
    
    /// Center Pin's Shadow image view offset to adjust custom assets Y Position
    public var shadowOffsetY: CGFloat = 0 {
        didSet {
            updateFrames(animated: false)
        }
    }
    
    /// Center Pin's Pin image view's image to assign a custom pin asset
    public var pinImage: UIImage? {
        didSet {
            pin.pin.image = pinImage
            pin.pin.sizeToFit()
        }
    }
    
    /// Center Pin's Shadow image view's image to assign a custom pin asset
    public var shadowImage: UIImage? {
        didSet {
            pin.shadow.image = shadowImage
            pin.shadow.sizeToFit()
        }
    }
    
    /// Center Pin's Shadow image view alpha value customization
    public var shadowAlpha: CGFloat = 0.5 {
        didSet {
            pin.shadow.alpha = shadowAlpha
        }
    }
    
    /// Alternate shadow image, if specified the center pin's shadow will change to this one while the user us dragging the map
    public var shadowImageWhenDragged: UIImage?
    
    /// DSCenterPinMapView's delegate. You can declare your customized delegate for more specific behaviour
    public var delegate: DSCenterPinMapViewDelegate?
    
    /// Returns true while the map is being dragged
    public var isDragging: Bool = false {
        didSet {
            if isDragging {
                dragAnimation()
            } else {
                dropAnimation()
            }
        }
    }
    
    //------------------------------------
    // MARK: - Overloaded Methods
    //------------------------------------

    override public init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    //------------------------------------
    // MARK: - Public Methods
    //------------------------------------
    
    /// This method should be called when the view containing DSCenterPinMapView frame changes or when the MapView's layoutMargins are updated to update the Center Pin Position to the new Center.
    /// - Parameter animated: If animated, the center pin will do a smooth transition to the new map center.
    public func updateFrames(animated: Bool) {
        if animated {
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
                self.setFrames()
                self.layoutIfNeeded()
            }, completion: nil)
        } else {
            setFrames()
        }
    }
    
    /// This method centers the map on the current user location
    /// - Parameter span: Default span is MKCoordinateSpan(latitudeDelta: 0.002, longitudeDelta: 0.002), you can specify a custom one if you need to.
    public func centerOnUserLocation(with span: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.002, longitudeDelta: 0.002)) {
        let region = MKCoordinateRegion(center: mapview.userLocation.coordinate, span: span)
        mapview.regionThatFits(region)
        mapview.setRegion(region, animated: true)
    }
    
    /// This method centers the map on the given location
    /// - Parameters:
    ///   - coordinate: Coordinate of the location where you want the map to center
    ///   - span: Default span is MKCoordinateSpan(latitudeDelta: 0.002, longitudeDelta: 0.002), you can specify a custom one if you need to.
    public func center(on coordinate: CLLocationCoordinate2D, span: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.002, longitudeDelta: 0.002)) {
        let region = MKCoordinateRegion(center: coordinate, span: span)
        mapview.regionThatFits(region)
        mapview.setRegion(region, animated: true)
    }
    
    /// If you want to create your own delegate for DSCenterPinMapView but still keep the core functionality you can call this method on your custom mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) and mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool)
    public func updateDragging() {
        if isDragging {
          isDragging = false
            delegate?.didEndDragging()
        } else {
            isDragging = true
            delegate?.didStartDragging()
        }
    }
    
    //------------------------------------
    // MARK: - Private Methods
    //------------------------------------
    
    /// Sets up DSCenterPinMapView
    private func setup() {
        
        mapview.frame = frame
        addSubview(mapview)
        mapview.delegate = self
        
        pin.isUserInteractionEnabled = false
        addSubview(pin)
        
        updateFrames(animated: false)
        
    }
    
    /// Updates views frames
    private func setFrames() {
        
        self.pin.frame = CGRect(x: self.mapview.center.x - self.pin.pin.frame.size.width / 2 + self.pinOffsetX,
                                y: self.mapview.layoutMarginsGuide.layoutFrame.midY - self.pin.pin.frame.size.height + self.pinOffsetY,
                                width: self.pin.frame.size.width,
                                height: self.pin.frame.size.height)
        
        self.pin.pin.frame = CGRect(x: self.pin.frame.size.width,
                               y: self.pin.frame.size.height,
                               width: self.pin.pin.frame.size.width,
                               height: self.pin.pin.frame.size.height)
        
        self.pin.shadow.frame = CGRect(x: self.pin.frame.size.width + self.shadowOffsetX,
                                  y: self.pin.frame.size.height + self.shadowOffsetY,
                                  width: self.pin.shadow.frame.size.width,
                                  height: self.pin.shadow.frame.size.height)
        
    }
    
    /// Animates center pin up when the map starts moving
    private func dragAnimation() {
        UIView.animate(withDuration: 0.2, animations: {
            if let alternateShadowImage = self.shadowImageWhenDragged {
                self.pin.shadow.image = alternateShadowImage
            }
            self.pin.shadow.transform = self.pin.shadow.transform.scaledBy(x: 0.7, y: 0.7)
            self.pin.shadow.alpha = self.shadowAlpha / 2
            self.pin.pin.transform = self.pin.transform.translatedBy(x: 0, y: -15)
        })
    }
    
    /// Animates center pin back down when the map stops moving
    private func dropAnimation() {
        UIView.animate(withDuration: 0.2, animations: {
            if self.shadowImageWhenDragged != nil {
                self.pin.shadow.image = self.shadowImage
            }
            self.pin.shadow.transform = CGAffineTransform.identity
            self.pin.shadow.alpha = self.shadowAlpha
            self.pin.pin.transform = CGAffineTransform.identity
        })
    }
    
}

//------------------------------------
// MARK: - MKMapViewDelegate
//------------------------------------

extension DSCenterPinMapView: MKMapViewDelegate {
    
    public func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        updateDragging()
    }
    
    public func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        updateDragging()
    }
    
}
