//
//  ResultsInterfaceController.swift
//  Watch4
//
//  Created by Macbook on 31/05/2017.
//  Copyright © 2017 Chappy-App. All rights reserved.
//

import WatchKit
import Foundation


class ResultsInterfaceController: WKInterfaceController {

     @IBOutlet var table: WKInterfaceTable!
     @IBOutlet var status: WKInterfaceLabel!
     @IBOutlet var done: WKInterfaceButton!
     
     var fetchedCurrencies = [(symbol: String, rate: Double)]()
     var amountToConvert = 0.0
     
     
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        guard let settings = context as? [String: String] else { return }
        guard let amount = settings["amount"] else { return }
        guard let baseCurrency = settings["base"] else { return }
     
        amountToConvert = Double(amount) ?? 50
        setTitle("\(amount) \(baseCurrency)")
     
        let defaults = UserDefaults.standard
        let selectedCurrencies = defaults.array(forKey: InterfaceController.selectedCurrenciesKey)
        as? [String] ?? InterfaceController.defaultCurrencies
     
     DispatchQueue.global(qos: .userInteractive).async {
          self.fetchData(for: baseCurrency, symbols: selectedCurrencies)
          
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
    
     @IBAction func doneTapped() {
     
          WKInterfaceController.reloadRootControllers(withNames: ["Home", "Currencies"], contexts: nil)
     }
     
     func fetchData(for baseCurrency: String, symbols: [String]) {
          
     //create a URL using the users input
     if let url = URL(string: "https://api.fixer.io/latest?base=\(baseCurrency)&symbols=\(symbols.joined(separator: ","))") {
               
          //attempt to fetch the contents of the URL
          if let contents = try? Data(contentsOf: url) {
               
               //it worked - parse and exit
               parse(contents)
               return
          }
     }
     
     //if we're still here, update the label on the main thread
     
     DispatchQueue.main.async {
     
          self.status.setText("Fetch failed")
     
     }
}


     func parse(_ contents: Data) {
     
          let json = JSON(data: contents)
          let rates = json["rates"].dictionaryValue
          
          for symbol in rates {
               
               let rateName = symbol.key
               let rateValue = symbol.value.doubleValue
               
               fetchedCurrencies.append((symbol: rateName, rate: rateValue))
             
          }
          
          fetchedCurrencies.sort {
               
               $0.symbol < $1.symbol
          }
          
          updateTable()
          status.setHidden(true)
          table.setHidden(false)
          done.setHidden(false)
          
     }
     
     func updateTable() {
     
          //load as many rows as we have currencies
          table.setNumberOfRows(fetchedCurrencies.count, withRowType: "Row")
          
          //loop over each currency, getting its position and symbol
          for (index, currency) in fetchedCurrencies.enumerated() {
               
               //find row at position
               guard let row = table.rowController(at: index) as? CurrencyRow else { return }
               
               //multiply the rate by the user's input amount
               let value = currency.rate * amountToConvert
               
               //convert it to a rounded string
               let formattedValue = String(format: "%.2f", value)
               
               //show it in the label
               row.textLabel.setText("\(formattedValue) \(currency.symbol)")
               
               }
          }
  
}
