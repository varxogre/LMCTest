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
    
    func prepareWhitespace() -> String {
        guard let formattedString =  self.addingPercentEncoding(
                withAllowedCharacters: .urlUserAllowed)
        else { return self }
        return formattedString
    }
    
    func removeHTMLTags() -> String {
        guard let data = self.data(using: .utf16) else { return self }
        guard let attributedString = try? NSAttributedString(
                data: data, options: [.documentType: NSAttributedString.DocumentType.html],
                documentAttributes: nil)
        else { return self }
        return attributedString.string
    }
}

extension Date {
    func customizeDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: self)
    }
}
