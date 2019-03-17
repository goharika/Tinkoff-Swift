//
//  ViewController.swift
//  TinkOFFTest
//
//  Created by Gohar on 21/02/2019.
//  Copyright © 2019 AG. All rights reserved.
//

import UIKit
import ASDKCore
import ASDKUI

//@interface BookItem : NSObject
//
//@property (nonatomic, strong) UIImage *cover;
//@property (nonatomic, strong) NSString *title;
//@property (nonatomic, strong) NSString *author;
//@property (nonatomic, strong) NSNumber *cost;
//@property (nonatomic, strong) NSString *bookDescription;
//
//- (instancetype)initWithCover:(UIImage *)cover
//title:(NSString *)title
//author:(NSString *)author
//cost:(NSNumber *)cost
//bookDescription:(NSString *)description;
//
//- (NSString *)amountAsString;
//
//@end

struct BookItem {
    
   // var cover: UIImage
    var title: String
    var author: String
    var cost: NSNumber
    var bookDescription: String
}

class ViewController: UIViewController {

    @IBOutlet weak var buyButton: UIButton!
    
    var item = BookItem.init(title: "Robinzon", author: "Daniel Defo", cost: 200, bookDescription: "Lav girq e")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    func buyItem() {
        
        ASDKCardsListDataController(acquiringSdk: PayController.acquiringSdk(), customerKey: PayController.customerKey())
        ASDKCardsListDataController.instance().updateCardsList(successBlock: {
            if ASDKCardsListDataController.instance().cardWithRebillId() == nil {
                self.buyFromCard()
            } else {
                self.buyCharge()
            }
        }, errorBlock: { error in
            self.buyFromCard()
        })

    }
    
    func buyCharge() {
        print("BUY CHARGE")
//        PayController.charge(withRebillId: ASDKCardsListDataController.instance().cardWithRebillId().rebillId(), amount: item.cost, description: nil, additionalPaymentData: [
//            "Email": "a@test.ru",
//            "Phone": "+71234567890"
//            ], receiptData: [
//                "Email": "a@test.ru",
//                "Taxation": "osn",
//                "Items": [
//                    [
//                        "Name": "Название товара 1",
//                        "Price": NSNumber(value: 10000),
//                        "Quantity": NSNumber(value: 1),
//                        "Amount": NSNumber(value: 10000),
//                        "Tax": "vat10"
//                    ],
//                    [
//                        "Name": "Название товара 2",
//                        "Price": NSNumber(value: 10000),
//                        "Quantity": NSNumber(value: 1),
//                        "Amount": NSNumber(value: 10000),
//                        "Tax": "vat118"
//                    ]
//                ]
//            ], fromViewController: self, success: { paymentInfo in
//                if let paymentId = paymentInfo?.paymentId {
//                    print("\(paymentId)")
//                }
//        }, error: { error in
//            if let error = error {
//                print("\(error)")
//            }
//        })
    }

    
    func buyFromCard() {
        
        let shopsData = [[
            "Amount": NSNumber(value: 10000),
            "Fee": "20",
            "Name": "Shop1",
            "ShopCode": "100"
        ],
        [
        "Amount": NSNumber(value: 10000),
        "Name": "Shop2",
        "ShopCode": "101"
        ]]
        
        let shopDa1 = ["Email": "a@a.ru",
                       "Items": [
                        "Amount": NSNumber(value: 10000),
                        "Name": "name1",
                        "Price": NSNumber(value: 10000),
                        "Quantity": NSNumber(value: 1),
                        "Tax": "vat20",
                        "QUANTITY_SCALE_FACTOR": NSNumber(value: 3),
                        "ShopCode": "100",
                        "Taxation": "esn"]
                        ] as? [String: Any]
        let shop2 = ["Email": "a@a.ru",
                     "Items":
                        [
                            "Amount": NSNumber(value: 500),
                            "Name": "name1",
                            "Price": NSNumber(value: 200),
                            "Quantity": NSNumber(value: 1),
                            "Tax": "vat20",
                            "QUANTITY_SCALE_FACTOR": NSNumber(value: 3)
                        ],
            "ShopCode": "101",
            "Taxation": "esn"] as? [String: Any]
        
        
        
        let shopsReceiptsData = [shopDa1, shop2]
        
        PayController.buyItem(withName: item.title, description: item.bookDescription, amount: item.cost, recurrent: !ASDKTestSettings.makeCharge(), makeCharge: ASDKTestSettings.makeCharge(), additionalPaymentData: nil, receiptData: nil, shopsData:shopsData,
                              shopsReceiptsData:shopsReceiptsData as! [[String : Any]],
            from: self,
            success: { paymentInfo in
                if let paymentId = paymentInfo?.paymentId {
                    print("\(paymentId)")
                }
        }, cancelled: {
            print("Canceled")
        }, error: { error in
            if let error = error {
                print("\(error)")
            }
        })
    }

    
    
    @IBAction func buyButtonAction(_ sender: UIButton) {
        self.buyFromCard()
    }
    
}

