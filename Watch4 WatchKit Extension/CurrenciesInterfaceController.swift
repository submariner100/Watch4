//
//  CurrenciesInterfaceController.swift
//  Watch4
//
//  Created by Macbook on 25/05/2017.
//  Copyright © 2017 Chappy-App. All rights reserved.
//

import WatchKit
import Foundation


class CurrenciesInterfaceController: WKInterfaceController {

     @IBOutlet var table: WKInterfaceTable!
     
     let selectedColor = UIColor(red: 0, green: 0.55, blue: 0.25, alpha: 1)
     let deselectColor = UIColor(red: 0.3, green: 0, blue: 0, alpha: 1)
     
     
    
     override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
          //set up as many rows as we have currencies
          table.setNumberOfRows(InterfaceController.currencies.count, withRowType: "Row")
          
          //load the list of selected currencies, or use the default list
          let defaults = UserDefaults.standard
          let selectedCurrencies = defaults.array(forKey: InterfaceController.selectedCurrenciesKey) as? [String] ?? InterfaceController.defaultCurrencies
          
          //loop over all the currencies, configuring the table rows
          for (index, currency) in InterfaceController.currencies.enumerated() {
               
               guard let row = table.rowController(at: index) as? CurrencyRow else { continue }
               row.textLabel.setText(currency)
               
               //color the rows group depending on wether it's selected
               if selectedCurrencies.contains(currency) {
                    
                    row.group.setBackgroundColor(selectedColor)
                    
               } else {
                    
                    row.group.setBackgroundColor(deselectColor)
                    
               }
          }
     }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
