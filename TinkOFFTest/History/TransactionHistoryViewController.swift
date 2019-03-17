//
//  TransactionHistoryViewController.swift
//  TinkOFFTest
//
//  Created by Gohar on 21/02/2019.
//  Copyright © 2019 AG. All rights reserved.
//

import UIKit

class TransactionHistoryViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var transactions: [Any]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "История покупок"
        tableView.register(TransactionDetailTableViewCell.self, forCellReuseIdentifier: "cellID")
        //register(UINib(nibName: "TransactionDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "cellID")
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.transactions = TransactionHistoryModelController.sharedInstance.tra
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
