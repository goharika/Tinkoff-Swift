//
//  UIUserInterfaceIdiom.swift
//  TinkOFFTest
//
//  Created by Gohar on 21/02/2019.
//  Copyright © 2019 AG. All rights reserved.
//

import UIKit

enum UIUserInterfaceIdiom : Int {
    
    case unspecified
    
    case phone // iPhone and iPod touch style UI
    case pad // iPad style UI
}

extension  UIDevice {
    
    static var _isIPhoneX:Int = -1;//in case of -1 it's undefined
    
    class func isIPhoneX() -> Bool {
        if _isIPhoneX >= 0 {
            return _isIPhoneX > 0
        }
        var iphoneX = false
        let screenSize = UIScreen.main.bounds.size
        if screenSize.height == 812 {
            iphoneX = true
        }
        _isIPhoneX = iphoneX ? 1 : 0;
        return iphoneX;
    }
    
    class func isIpad() -> Bool {
        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        
        switch (deviceIdiom) {
        case .pad:
            return true
        default:
            return false
        }
    }
}
