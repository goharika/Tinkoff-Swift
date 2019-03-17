//
//  TransactionHistoryModelController.swift
//  TinkOFFTest
//
//  Created by Gohar on 21/02/2019.
//  Copyright © 2019 AG. All rights reserved.
//

import Foundation

struct DataSource {
    
    let paymentId: String
    let paymentInfo: String
    let summ: NSNumber
    let description : String
    let status: String
    
    var dictionary: [String: Any] {
        return ["paymentId": paymentId,
                "paymentInfo": paymentInfo,
                "summ": summ,
                "description": description,
                "status": status]
    }
    var nsDictionary: NSDictionary {
        return dictionary as NSDictionary
    }
    
}

class TransactionHistoryModelController: NSObject {
    
    static var sharedInstacne_:TransactionHistoryModelController? = nil
    
    class var sharedInstance: TransactionHistoryModelController {
        
        if sharedInstacne_ == nil {
            sharedInstacne_ = TransactionHistoryModelController()
        }
        return sharedInstacne_!
    }
    
    var dataSourceE : [String: Any]?
    
    override init() {
        super.init()
     //
        
        self.dataSourceE = [String: Any]()

       // let _dataSource = UserDefaults.standard.object(forKey: Constants.kTransactionHistory) as? [String]
//        if dataSource != nil && (dataSource is [Int]) {
//            if let dataSource = _dataSource as? [String] {
              //  self.dataSourceE.add
        //append(contentsOf: _dataSource)
//            }
//        }
        //return self
    }
    
    
//    func updateTransaction(_ info: [String : Any]?) {
//        for index in 0..<dataSource?.count() ?? 0 {
//            let transaction = dataSource?[index] as? [AnyHashable : Any]
//
//            if (info?["paymentId"] == transaction?["paymentId"]) {
//                if let info = info {
//                    dataSource?[index] = info
//                }
//                saveTransactions()
//                break
//            }
//        }
//    }

    
    func addTransaction(_ info:[String: Any]) {
       // if let info = info as? [String : Any] {
            let dict = DataSource.init(paymentId: "sds", paymentInfo: "sdsd", summ: 20, description: "sfsdsf", status: "dfdfd")
            dataSourceE = dict.dictionary
        
    //    }
        saveTransactions()
    }
    
    
    
//    func transactions() -> [Any]? {
//        return dataSource?.copy()
//    }
//    
    func saveTransactions() {
        UserDefaults.standard.set(dataSourceE, forKey: Constants.kTransactionHistory)
        UserDefaults.standard.synchronize()
    }

    
    func rebillId() -> Int? {
        return UserDefaults.standard.object(forKey: Constants.kTransactionRebillId) as? Int
    }
    
    func saveRebillId(_ rebillId: Int?) {
        UserDefaults.standard.set(rebillId, forKey: Constants.kTransactionRebillId)
        UserDefaults.standard.synchronize()
    }


    
}
