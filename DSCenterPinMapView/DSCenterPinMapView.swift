//
//  DSCenterPinMapView.swift
//  steve123s
//
//  Created by Daniel Esteban Salinas on 03/08/20.
//  Copyright © 2020 com.inventivetech. All rights reserved.
//

import UIKit
import MapKit

protocol DSCenterPinMapViewDelegate {
    func didStartDragging()
    func didEndDragging()
}

class DSCenterPinMapView: UIView {
    
    var pin: DSCenterPinView = DSCenterPinView()
    var mapview: MKMapView = MKMapView()
    
    var pinOffsetX: CGFloat = 0 {
        didSet {
            updateFrames(animated: false)
        }
    }
    
    var pinOffsetY: CGFloat = 0 {
        didSet {
            updateFrames(animated: false)
        }
    }
    
    var shadowOffsetX: CGFloat = 0 {
        didSet {
            updateFrames(animated: false)
        }
    }
    
    var shadowOffsetY: CGFloat = 0 {
        didSet {
            updateFrames(animated: false)
        }
    }
    
    var pinImage: UIImage? {
        didSet {
            pin.pin.image = pinImage
            pin.pin.sizeToFit()
        }
    }
    
    var shadowImage: UIImage? {
        didSet {
            pin.shadow.image = shadowImage
            pin.shadow.sizeToFit()
        }
    }
    
    var shadowAlpha: CGFloat = 0.5 {
        didSet {
            pin.shadow.alpha = shadowAlpha
        }
    }
    
    var shadowImageWhenDragged: UIImage?
    
    var delegate: DSCenterPinMapViewDelegate?
    
    var isDragging: Bool = false {
        didSet {
            if isDragging {
                dragAnimation()
            } else {
                dropAnimation()
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        
        mapview.frame = frame
        addSubview(mapview)
        mapview.delegate = self
        
        pin.isUserInteractionEnabled = false
        addSubview(pin)
        
        updateFrames(animated: false)
        
    }
    
    func updateFrames(animated: Bool) {
        if animated {
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
                self.setFrames()
                self.layoutIfNeeded()
            }, completion: nil)
        } else {
            setFrames()
        }
    }
    
    func centerOnUserLocation(with span: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.002, longitudeDelta: 0.002)) {
        let region = MKCoordinateRegion(center: mapview.userLocation.coordinate, span: span)
        mapview.regionThatFits(region)
        mapview.setRegion(region, animated: true)
    }
    
    func center(on coordinate: CLLocationCoordinate2D, span: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.002, longitudeDelta: 0.002)) {
        let region = MKCoordinateRegion(center: coordinate, span: span)
        mapview.regionThatFits(region)
        mapview.setRegion(region, animated: true)
    }
    
    func updateDragging() {
        if isDragging {
          isDragging = false
            delegate?.didEndDragging()
        } else {
            isDragging = true
            delegate?.didStartDragging()
        }
    }
    
    func dragAnimation() {
        pin.canLayout = false
        
        UIView.animate(withDuration: 0.2, animations: {
            if let alternateShadowImage = self.shadowImageWhenDragged {
                self.pin.shadow.image = alternateShadowImage
            }
            self.pin.shadow.transform = self.pin.shadow.transform.scaledBy(x: 0.7, y: 0.7)
            self.pin.shadow.alpha = self.shadowAlpha / 2
            self.pin.pin.transform = self.pin.transform.translatedBy(x: 0, y: -15)
        }) { (_) in
            self.pin.canLayout = true
        }
    }
    
    func dropAnimation() {
        pin.canLayout = false
        
        UIView.animate(withDuration: 0.2, animations: {
            if self.shadowImageWhenDragged != nil {
                self.pin.shadow.image = self.shadowImage
            }
            self.pin.shadow.transform = CGAffineTransform.identity
            self.pin.shadow.alpha = self.shadowAlpha
            self.pin.pin.transform = CGAffineTransform.identity
        }) { (_) in
            self.pin.canLayout = true
        }
    }
    
    private func setFrames() {
        
        self.pin.frame = CGRect(x: self.mapview.center.x - self.pin.pin.frame.size.width / 2 + self.pinOffsetX,
                                y: self.mapview.layoutMarginsGuide.layoutFrame.center.y - self.pin.pin.frame.size.height + self.pinOffsetY,
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
    
}

extension DSCenterPinMapView: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        updateDragging()
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        updateDragging()
    }
    
}
