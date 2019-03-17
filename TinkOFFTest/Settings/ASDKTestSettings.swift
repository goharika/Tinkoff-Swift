//
//  ASDKTestSettings.swift
//  TinkOFFTest
//
//  Created by Gohar on 21/02/2019.
//  Copyright © 2019 AG. All rights reserved.
//

import Foundation

class ASDKTestSettings {
    
    class func testTerminals() -> [Any]? {
        return [Constants.kASDKTestTerminalKey1, Constants.kASDKTestTerminalKey2, Constants.kASDKTestTerminalKey3]
    }
    
    class func testActiveTerminal() -> String? {
        var result = ASDKTestSettings.value(forKey: Constants.kActiveTerminal) as? String
        if result == nil {
            result = Constants.kASDKTestTerminalKey1
        }
        
        return result
    }

    
    class func setActiveTestTerminal(value: String) {
        ASDKTestSettings.saveValue(value, forKey: Constants.kActiveTerminal)
    }
    
    class func testTerminalPassword() -> String? {
        return Constants.kASDKTestPassword
    }
    
    class func testPublicKey() -> String? {
        return Constants.kASDKTestPublicKey
    }

    class func setCustomButtonCancel(_ value: Bool) {
        ASDKTestSettings.saveValue(value, forKey: Constants.kSettingCustomButtonCancel)
    }
    
    class func customButtonCancel() -> Bool {
        
        return ASDKTestSettings.value(forKey: Constants.kSettingCustomButtonCancel) as? Bool ?? false
    }
    
    class func setCustomButtonPay(_ value: Bool) {
        ASDKTestSettings.saveValue(NSNumber(value: value), forKey: Constants.kSettingCustomButtonPay)
    }

    class func customButtonPay() -> Bool {
        return (ASDKTestSettings.value(forKey: Constants.kSettingCustomButtonPay) != nil)
    }
    
//    class func setCustomNavBarColor(value: Bool) {
//        ASDKTestSettings.saveValue(value, forKey: Constants.)
//    }
    
    class func setMakeCharge(value: Bool) {
        
        ASDKTestSettings.saveValue(value, forKey: Constants.kSettingMakeCharge)
    }
    
    class func makeCharge() -> Bool {
        return (ASDKTestSettings.value(forKey: Constants.kSettingMakeCharge) != nil)
    }
    
    class func setMakeNewCard(value: Bool) {
        
        ASDKTestSettings.saveValue(value, forKey: Constants.kSettingMakeNewCard)
    }
    
    class func makeNewCard() -> Bool {
        return (ASDKTestSettings.value(forKey: Constants.kSettingMakeNewCard) != nil)
    }
    
    
    class func saveValue(_ value: Any?, forKey key: String?) {
        if value != nil {
            UserDefaults.standard.set(value, forKey: key ?? "")
        } else {
            UserDefaults.standard.removeObject(forKey: key ?? "")
        }
        
        UserDefaults.standard.synchronize()
    }

    
    class func value(forKey key: String) -> Any? {
        return UserDefaults.standard.object(forKey: key)
    }

}
