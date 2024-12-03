//
//  QuoteTableViewController.swift
//  InspoQuotes
//
//  Created by Angela Yu on 18/08/2018.
//  Copyright © 2018 London App Brewery. All rights reserved.
//

import UIKit
import StoreKit

class QuoteTableViewController: UITableViewController, SKPaymentTransactionObserver {
    
    
    
    let productId = "com.kakay-to zalupa"
    
    var quotesToShow = [
        "Our greatest glory is not in never falling, but in rising every time we fall. — Confucius",
        "All our dreams can come true, if we have the courage to pursue them. – Walt Disney",
        "It does not matter how slowly you go as long as you do not stop. – Confucius",
        "Everything you’ve ever wanted is on the other side of fear. — George Addair",
        "Success is not final, failure is not fatal: it is the courage to continue that counts. – Winston Churchill",
        "Hardships often prepare ordinary people for an extraordinary destiny. – C.S. Lewis"
    ]
    
    let premiumQuotes = [
        "Believe in yourself. You are braver than you think, more talented than you know, and capable of more than you imagine. ― Roy T. Bennett",
        "I learned that courage was not the absence of fear, but the triumph over it. The brave man is not he who does not feel afraid, but he who conquers that fear. – Nelson Mandela",
        "There is only one thing that makes a dream impossible to achieve: the fear of failure. ― Paulo Coelho",
        "It’s not whether you get knocked down. It’s whether you get up. – Vince Lombardi",
        "Your true success in life begins only when you make the commitment to become excellent at what you do. — Brian Tracy",
        "Believe in yourself, take on your challenges, dig deep within yourself to conquer fears. Never let anyone bring you down. You got to keep going. – Chantal Sutherland"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        SKPaymentQueue.default().add(self)
        
        if isPurchased() {
            showPremiumQuotes()
        }
        
    }

    // MARK: - Table view data source

    
//    количество секций
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isPurchased() {
            return quotesToShow.count
        } else {
            return quotesToShow.count + 1
        }
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuoteCell", for: indexPath)
        
        if #available(iOS 14.0, *) {
            var content = cell.defaultContentConfiguration()
            
            if indexPath.row < quotesToShow.count {
                content.text = quotesToShow[indexPath.row]
                content.textProperties.numberOfLines = 0
                content.textProperties.color = .black
                cell.accessoryType = .none
            } else {
                content.text = "Get More Quotes"
                content.textProperties.color = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
                cell.accessoryType = .disclosureIndicator
            }
            
            cell.contentConfiguration = content
        } else {
          
            if indexPath.row < quotesToShow.count {
                cell.textLabel?.text = quotesToShow[indexPath.row]
                cell.textLabel?.numberOfLines = 0
                cell.accessoryType = .none
            } else {
                cell.textLabel?.text = "Get More Quotes"
                cell.textLabel?.textColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
                cell.accessoryType = .disclosureIndicator
            }
        }
        
        return cell
    }

    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == quotesToShow.count {
            print("f")
            buyPremium()
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
    func buyPremium() {
        if SKPaymentQueue.canMakePayments() {
            //если есть разрешение на покупки
            
            let paymentRequest = SKMutablePayment()
            paymentRequest.productIdentifier = productId
            SKPaymentQueue.default().add(paymentRequest)
            
        } else {
            //если нет разрешение на покупки
            print("user can't make payments")
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            if transaction.transactionState == .purchased {
                showPremiumQuotes()
                
                SKPaymentQueue.default().finishTransaction(transaction)
                print("купленно")
                
            } else if transaction.transactionState == .failed {
                
                if let error = transaction.error {
                    let errorDescription = error.localizedDescription
                    print("trans error - \(errorDescription)")
                }
                SKPaymentQueue.default().finishTransaction(transaction)
                print("не куплено")
                
            } else if transaction.transactionState == .restored {
                navigationItem.setRightBarButton(nil, animated: true)
                
                showPremiumQuotes()
                print("trans restore")
                SKPaymentQueue.default().finishTransaction(transaction)

            }
            
        }
    }
    
    func showPremiumQuotes() {
        UserDefaults.standard.set(true, forKey: productId)
        
        quotesToShow.append(contentsOf: premiumQuotes)
        tableView.reloadData()
    }
    
    
    func isPurchased() -> Bool {
        let purchaseStatus = UserDefaults.standard.bool(forKey: productId)
        if purchaseStatus {
            return true
        } else {
            
            return false
        }
    }
    
    
    
    
    
    
    @IBAction func restorePressed(_ sender: UIBarButtonItem) {
        
    }


}
