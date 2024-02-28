//
//  DataLoader.swift
//  ChartsSwiper
//
//  Created by Jakob Ossmann on 23/12/2023.
//
// Load the CSV data into the App

import Foundation
import CoreData


class DataLoader {
    static func loadCSVAndInsertIntoCoreData(fileName: String, context: NSManagedObjectContext) {
        let csvData = loadCSV(from: fileName)
        print("Loaded CSV data")
        context.perform {
            insertIntoCoreData(csvData: csvData, context: context)
            // Handle saving and error catching here
        }
    }

    // load the file
    private static func loadCSV(from fileName: String) -> [[String]] {
        // First, get the URL for the file in the app bundle
        guard let fileURL = Bundle.main.url(forResource: fileName, withExtension: nil) else {
            fatalError("File not found")
        }
        
        do {
            // Read the content of the file
            let content = try String(contentsOf: fileURL)
            
            // Split the content into lines
            let lines = content.components(separatedBy: .newlines).filter { !$0.isEmpty }
            
            // Split each line by the tab character to get an array of the columns
            let csvData = lines.map { $0.components(separatedBy: ",") }
            
            return csvData
        } catch {
            fatalError("Cannot load file: \(error)")
        }
    }


    // insert the rows from the CSV file into CoreData
    private static func insertIntoCoreData(csvData: [[String]], context: NSManagedObjectContext) {
        // Start from index 1 to skip the header row
        for i in 1..<csvData.count {
            let row = csvData[i]
            guard row.count >= 5,
                  let peRatio = Float(row[2]), // PE Ratio is in the 3rd column
                  let dividendYield = Float(row[3]), // Dividend Yield is in the 4th column
                  let earningsGrowth = Float(row[4]) // Earnings Growth is in the 5th column
            else {
                continue
            }

            let newStock = DBStock(context: context)
            newStock.symbol = row[0] // Symbol is in the 1st column
            newStock.name = row[1] // Name is in the 2nd column
            newStock.peRatio = peRatio
            newStock.dividendYield = dividendYield
            newStock.earningsGrowth = earningsGrowth
            // Print statement to verify correct data insertion
            print("Inserted: \(newStock.symbol), Name: \(newStock.name), PE Ratio: \(newStock.peRatio), Dividend Yield: \(newStock.dividendYield), Earnings Growth: \(newStock.earningsGrowth)")
        }

        do {
            try context.save()
        } catch let error as NSError {
            // Handle save error
            print("Could not save. \(error), \(error.userInfo)")
        }
    }


}
