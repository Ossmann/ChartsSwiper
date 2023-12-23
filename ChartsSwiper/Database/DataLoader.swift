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
        print("Loaded CSV data: \(csvData)")
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
            guard row.count >= 2,
                  let peRatio = Float(row[1]) else {
                continue
            }

            let newStock = DBStock(context: context)
            newStock.symbol = row[0]
            newStock.peRatio = peRatio
            print("Inserted: \(newStock.symbol), PE Ratio: \(newStock.peRatio)")
        }

        do {
            try context.save()
        } catch let error as NSError {
            // Handle save error
            print("Could not save. \(error), \(error.userInfo)")
        }
    }

}
