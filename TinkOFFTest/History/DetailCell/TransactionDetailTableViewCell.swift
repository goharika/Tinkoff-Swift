//
//  TransactionDetailTableViewCell.swift
//  TinkOFFTest
//
//  Created by Gohar on 21/02/2019.
//  Copyright © 2019 AG. All rights reserved.
//

import UIKit

class TransactionDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var refundButton: UIButton!
    @IBOutlet weak var recurringButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func setStaus(status:String) {
        self.statusLabel.text = status
    }
    
    func setDescription(description: String) {
        self.descriptionLabel.text = description
    }
    
    func setPaymentId(paymentId: String) {
        self.setPaymentId(paymentId: paymentId)
    }
    
    func setHiddenRefund(hidden: Bool) {
        self.setHiddenRefund(hidden: hidden)
    }
    
    func setEnabledRefund(hidden: Bool) {
        self.refundButton.isHidden = hidden
    }
    
    func setHiddenRecurring(hidden: Bool) {
        self.recurringButton.isHidden = hidden
    }
    


    func addButtonRefundTarget(_ target: Any?, action: Selector, forControlEvents controlEvents: UIControl.Event) {
        refundButton.removeTarget(target, action: nil, for: controlEvents)
        refundButton.addTarget(target, action: action, for: controlEvents)
    }

    
    func addButtonRecurringTarget(_ target: Any?, action: Selector, forControlEvents controlEvents: UIControl.Event) {
        recurringButton.removeTarget(target, action: nil, for: controlEvents)
        recurringButton.addTarget(target, action: action, for: controlEvents)
    }
    
}
