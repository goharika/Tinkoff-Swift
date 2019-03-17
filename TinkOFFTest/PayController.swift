//
//  PayController.swift
//  TinkOFFTest
//
//  Created by Gohar on 21/02/2019.
//  Copyright © 2019 AG. All rights reserved.
//

import UIKit
import ASDKCore
import ASDKUI
import PassKit

class PayController: UIViewController {
    
    class func acquiringSdk() -> ASDKAcquiringSdk? {
        let stringKeyCreator = ASDKStringKeyCreator(publicKeyString: ASDKTestSettings.testPublicKey())
        let acquiringSdk = ASDKAcquiringSdk(terminalKey: ASDKTestSettings.testActiveTerminal(),
                                            payType: nil,
                                            password: ASDKTestSettings.testTerminalPassword(),
                                            publicKeyDataSource: stringKeyCreator)
        
        acquiringSdk?.debug = true
        acquiringSdk?.testDomain = true
        acquiringSdk?.logger = nil
        
        return acquiringSdk
    }
    
    class func paymentFormStarter() -> ASDKPaymentFormStarter? {
        return ASDKPaymentFormStarter.init(acquiringSdk: PayController.acquiringSdk())
    }
    
    class func customerKey() -> String? {
        return "testCustomerKey1@gmail.com"
    }
    
    class func alertWithError(error: ASDKAcquringSdkError?) -> UIAlertController {
        let alertTitle = error?.errorMessage()
        // errorMessage != nil ? error?.errorMessage : NSLocalizedString("CanceledPayment", comment: "Оплата отменена")
        let alertDetails = error?.errorDetails != nil ? error?.errorDetails : error?.userInfo[kASDKStatus]
        
        let alertController = UIAlertController(title: alertTitle, message: alertDetails as? String, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: NSLocalizedString("Close", comment: "Закрыть"), style: .cancel, handler: { action in
            alertController.dismiss(animated: true)
        }))
        
        return alertController
    }
  
    
    class func alertForCancel(title: String) -> UIAlertController {
        
        let alertController = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Закрыть", style: .cancel) { (action) in
            alertController.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(cancelAction)
        return alertController
    }
    
    
    class func alertAttachCardSuccessfull(cardId: String) -> UIAlertController {
        
        let alertController = UIAlertController(title: "Карта успешно привязана", message: "card id = \(cardId)", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Закрыть", style: .cancel) { (action) in
            alertController.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(cancelAction)
        return alertController
    }
    
    class func buyItem(withName name: String?,
                       description: String?,
                       amount: NSNumber?,
                       recurrent: Bool,
                       makeCharge: Bool,
                       additionalPaymentData data: [String : Any]?,
                       receiptData: [String : Any]?,
                       from viewController: UIViewController?,
                       success onSuccess: @escaping (_ paymentInfo: ASDKPaymentInfo?) -> Void,
                       cancelled onCancelled: @escaping () -> Void,
                       error onError: @escaping (_ error: ASDKAcquringSdkError?) -> Void) {
        
        PayController.buyItem(withName: name,
                              description: description,
                              amount: amount,
                              recurrent: recurrent,
                              makeCharge: makeCharge,
                              additionalPaymentData: data,
                              receiptData: receiptData,
                              shopsData: nil,
                              shopsReceiptsData: nil,
                              from: viewController,
                              success: onSuccess,
                              cancelled: onCancelled,
                              error: onError)
    }
    
    class func buyItem(withName name: String?,
                       description: String?,
                       amount: NSNumber?,
                       recurrent: Bool,
                       makeCharge: Bool,
                       additionalPaymentData data: [String : Any]?,
                       receiptData: [String : Any]?,
                       shopsData: [[String: Any]]?,
                       shopsReceiptsData: [[String: Any]]?,
                       from viewController: UIViewController?,
                       success onSuccess: @escaping (_ paymentInfo: ASDKPaymentInfo?) -> Void,
                       cancelled onCancelled: @escaping () -> Void,
                       error onError: @escaping (_ error: ASDKAcquringSdkError?) -> Void) {
        
        let paymentFormStarter: ASDKPaymentFormStarter = PayController.paymentFormStarter()!
        let randomOrderId = arc4random()
        let loc = ASDKLocalized.sharedInstance()
        loc.setLocalizedBundle(Bundle.main)
        loc.setLocalizedTable("ASDKlocalizableRu")
        
        //Настройка дизайна
        let designConfiguration: ASDKDesignConfiguration = paymentFormStarter.designConfiguration
        // используем ASDKTestSettings для переключения настроект во время работы приложения, для быстрой демонстрации
        
        if ASDKTestSettings.customButtonPay() {
            let cancelButton = UIBarButtonItem.init(title: "Отказаться", style: .plain, target: nil, action: nil)
            cancelButton.tintColor = .red
            designConfiguration.setCustomBackButton(cancelButton)
        }
        
        let itemss = [TableViewCellType.CellEmpty20px.rawValue,
                      TableViewCellType.CellProductTitle.rawValue,
                      TableViewCellType.CellProductDescription.rawValue,
                      TableViewCellType.CellAmount.rawValue,
                      TableViewCellType.CellEmptyFlexibleSpace.rawValue,
                      TableViewCellType.CellPaymentCardRequisites.rawValue,
                      TableViewCellType.CellEmail.rawValue,
                      TableViewCellType.CellEmpty20px.rawValue,
                      TableViewCellType.CellEmptyFlexibleSpace.rawValue,
                      TableViewCellType.CellPayButton.rawValue,
                      TableViewCellType.CellSecureLogos.rawValue,
                      TableViewCellType.CellEmpty20px.rawValue]
        
        designConfiguration.setPayFormItems(itemss)
        
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            designConfiguration.setModalPresentationStyle(.formSheet)
        }
        
        if ASDKTestSettings.customButtonPay() {
            let payButton = UIButton(frame: CGRect(x: 0, y: 0, width: 280, height: 60))
            payButton.backgroundColor = .blue
            payButton.setTitle("Оплатить", for: .normal)
            payButton.setTitleColor(.black, for: .normal)
            payButton.setTitleColor(.white, for: .normal)
            payButton.layer.cornerRadius = 10
            payButton.clipsToBounds = true
            designConfiguration.setCustomPay(payButton)
        }
        
        designConfiguration.setPayViewTitle("Экран оплаты")
        
        // MARK: Scanner : CardIO needed
        //paymentFormStarter.cardScanner = ASDCa
        
        paymentFormStarter.presentPaymentForm(from: viewController,
                                              orderId: String(randomOrderId),
                                              amount: amount,
                                              title: name,
                                              description: description,
                                              cardId: ASDKTestSettings.makeNewCard() ? nil : "",// nil - новая нужно вводить реквизиты карты, @"" - последняя сохраненная, @"836252" - карта по CardId
                                              email: "test@gmail.com",
                                              customerKey: PayController.customerKey(),
                                              recurrent: recurrent,
                                              makeCharge: makeCharge,
                                              additionalPaymentData: data,
                                              receiptData: receiptData,
                                              success: { (paymentInfo) in
                            TransactionHistoryModelController.sharedInstance.addTransaction([
                                                     "paymentId":paymentInfo?.paymentId ?? "",
                                                     "paymentInfo":paymentInfo?.dictionary,
                                                     "summ":amount ?? 200,
                                                     "description":description ?? "Ha inch",
                                                     kASDKStatus:paymentInfo?.status])
                                                    print("Payment success")
                                                viewController?.present(PaymentSuccessViewController(), animated: true, completion: nil)
                                                    onSuccess(paymentInfo)
                                                //ASDKPaymentInfo
                                              },
                                              cancelled: {
                                                print("Canceeel")
                                                onCancelled()
                                               }) { (error) in
                                                    print("Error = \(error)")
                                            }
                            }
    
    class func checkStatusTransaction(_ paymentId: String?, from viewController: UIViewController?, success onSuccess: @escaping (_ status: ASDKPaymentStatus) -> Void, error onError: @escaping (_ error: ASDKAcquringSdkError?) -> Void) {
        let paymentFormStarter: ASDKPaymentFormStarter? = PayController.paymentFormStarter()
        
        paymentFormStarter?.checkStatusTransaction(paymentId, success: { status in
            onSuccess(status)
        }, error: { error in
            onError(error)
        })
    }
    class func refundTransaction(_ paymentId: String?, from viewController: UIViewController?, success onSuccess: @escaping () -> Void, error onError: @escaping (_ error: ASDKAcquringSdkError?) -> Void) {
        let paymentFormStarter: ASDKPaymentFormStarter? = PayController.paymentFormStarter()
        
        paymentFormStarter?.refundTransaction(paymentId, success: {
            onSuccess()
        }, error: { error in
            
            guard  let errorTitle = error?.errorMessage() else {
                return
            }
            //.count ?? 0 > 0 ? error?.errorMessage : "Reject error"
            
            let alertController = UIAlertController(title: errorTitle, message: "error?.errorDetails", preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: NSLocalizedString("Close", comment: "Закрыть"), style: .cancel, handler: { action in
                alertController.dismiss(animated: true)
            })
            
            alertController.addAction(cancelAction)
            
            viewController?.present(alertController, animated: true)
            
            onError(error)
        })
    }
    
    //  The converted code is limited to 2 KB.
    //  Upgrade your plan to remove this limitation.
    //
    class func attachCard(_ cardCheckType: String?, additionalData data: [AnyHashable : Any]?, from viewController: UIViewController?, success onSuccess: @escaping (_ response: ASDKResponseAddCardInit?) -> Void, cancelled onCancelled: @escaping () -> Void, error onError: @escaping (_ error: ASDKAcquringSdkError?) -> Void) {
        //////////////
        let paymentFormStarter: ASDKPaymentFormStarter? = PayController.paymentFormStarter()
        
        //Настройка дизайна
        let designConfiguration: ASDKDesignConfiguration? = paymentFormStarter?.designConfiguration
        // используем ASDKTestSettings для переключения настроект во время работы приложения, для быстрой демонстрации
//        if ASDKTestSettings.customButtonCancel() {
//            let cancelButton = UIBarButtonItem(title: NSLocalizedString("Cancel", comment: "Отмена"), style: .plain, target: nil, action: nil)
//            cancelButton.tintColor = UIColor.red
//            designConfiguration?.customBackButton() = cancelButton
//        }
        
        
//        designConfiguration?.attachCardItems = [
//            //@(CellProductTitle),
//            //@(CellProductDescription),
//            NSNumber(value: "CellPaymentCardRequisites"),
//            NSNumber(value: "CellEmail"),
//            NSNumber(value: "CellEmptyFlexibleSpace"),
//            NSNumber(value: "CellAttachButton"),
//            NSNumber(value: "CellSecureLogos"),
//            NSNumber(value: "CellEmpty20px")
//        ]
        
//        if UIDevice.current.userInterfaceIdiom == .pad {
//            designConfiguration?.modalPresentationStyle() = UIModalTransitionStyle.flipHorizontal
//          //  designConfiguration?.modalPresentationStyle = .formSheet
//        }
        
        //Настройка сканнера карт
        //paymentFormStarter?.cardScanner = ASDKCardIOScanner()
        
        paymentFormStarter?.presentAttachForm(from: viewController, formTitle: "Новая карта", formHeader: "Сохраните данные карты", description: "и оплачивайте, не вводя реквизиты", email: "test@gmail.com", cardCheckType: cardCheckType, customerKey: PayController.customerKey(), additionalData: data, success: { result in
            if let cardId = result?.cardId {
                print("\(cardId)")
            }
         //   viewController?.present(PayController.alertAttachCardSuccessfull(cardId: result?.cardId), animated: true)
            onSuccess(result)
            print("onsuccessss")
            
        }, cancelled: {
         //   viewController?.present(PayController.alert(forCancel: NSLocalizedString("CanceledAttachCard", comment: "Сохранение карты")), animated: true)
            onCancelled()
            print("cancelledd")
            
        }, error: { error in
            if let error = error {
                
                print(error)
           //     viewController?.present(PayController(error: error), animated: true)
            }
            onError(error)
        })

    }
    
//
//    class func charge(withRebillId rebillId: NSNumber?, amount: NSNumber?, description: String?, additionalPaymentData data: [AnyHashable : Any]?, receiptData: [AnyHashable : Any]?, from viewController: UIViewController?, success onSuccess: @escaping (_ paymentInfo: ASDKPaymentInfo?) -> Void, error onError: @escaping (_ error: ASDKAcquringSdkError?) -> Void) {
//        PayController.charge(withRebillId: rebillId, amount: amount, description: description, additionalPaymentData: data, receiptData: receiptData, shopsData: nil, shopsReceiptsData: nil, from: viewController, success: onSuccess, error: onError)
//    }
//
//    class func charge(withRebillId rebillId: NSNumber?, amount: NSNumber?, description: String?, additionalPaymentData data: [AnyHashable : Any]?, receiptData: [AnyHashable : Any]?, shopsData: [Any]?, shopsReceiptsData: [Any]?, from viewController: UIViewController?, success onSuccess: @escaping (_ paymentInfo: ASDKPaymentInfo?) -> Void, error onError: @escaping (_ error: ASDKAcquringSdkError?) -> Void) {
//
//
//        var paymentFormStarter: ASDKPaymentFormStarter? = PayController.paymentFormStarter()
//        var randomOrderId = Double(arc4random() % 10000000)
//        var loc = ASDKLocalized.sharedInstance() as? ASDKLocalized
//        var vc = PaymentSuccessViewController()
//        var nc = UINavigationController(rootViewController: vc)
//        onSuccess(paymentInfo)
//        //Настройка дизайна
//        var designConfiguration: ASDKDesignConfiguration? = paymentFormStarter?.designConfiguration
//
//        var nc = UINavigationController(rootViewController: vc)
//        onError(error)
//    }
    
}
