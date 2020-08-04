//
//  DSCenterPinView.swift
//  steve123s
//
//  Created by Daniel Esteban Salinas on 03/08/20.
//  Copyright © 2020 Steve123s. All rights reserved.
//

import UIKit

class DSCenterPinView: UIView {

    var pin: UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 200)) {
        didSet {
            pin.contentMode = .center
        }
    }
    var shadow: UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 200)) {
        didSet {
            shadow.contentMode = .center
        }
    }
    var startPosition: CGPoint = CGPoint.zero
    var canLayout: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        self.addSubview(shadow)
        self.addSubview(pin)
    }
    
}
