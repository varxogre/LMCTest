//
//  DateFormatterExtension.swift
//  LMCTest
//
//  Created by сергей on 03.02.2021.
//

import Foundation

extension String {
    func customizeDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if let date = dateFormatter.date(from: self) {
            dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
            return dateFormatter.string(from: date)
        }
        return self
    }
}

extension Date {
    func customizeDate() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    
        
        return self
    }
}