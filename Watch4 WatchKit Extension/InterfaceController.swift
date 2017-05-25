//
//  InterfaceController.swift
//  Watch4 WatchKit Extension
//
//  Created by Macbook on 25/05/2017.
//  Copyright © 2017 Chappy-App. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {

     @IBOutlet var amountLabel: WKInterfaceLabel!
     @IBOutlet var amountSlider: WKInterfaceSlider!
     @IBOutlet var currencyPicker: WKInterfacePicker!
     
     static let currencies = ["AUD", "CAD", "CHF", "CNY", "EUR", "GBP", "HKD", "JPY", "SGD", "USD"]
     static let defaultCurrencies = ["USD", "EUR"]
     var currentCurrency = "AUD"
     var currentAmount = 500
     static let selectedCurrenciesKey = "SelectedCurrencies"
     
     
    
     override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        var items = [WKPickerItem]()
        
        for currency in InterfaceController.currencies {
          
          let item = WKPickerItem()
          item.title = currency
          items.append(item)
       }
       
     currencyPicker.setItems(items)
     
     }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

     @IBAction func convertTapped() {
     
     
     }
     
     @IBAction func amountChanged(_ value: Float) {
     
          currentAmount = Int(value)
          amountLabel.setText(String(currentAmount))
          
     }
     
     @IBAction func baseCurrencychanged(_ value: Int) {
     
          currentCurrency = InterfaceController.currencies[value]
     }
}
