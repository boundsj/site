//
//  Post.swift
//  App
//
//  Created by Jesse Bounds on 12/23/18.
//

import Foundation

struct Post: Codable {
    var title: String
    var link: String
    var summary: String?
    var content: String
    var date: Date
    var formattedDate: String

    init(title: String, link: String, summary: String?, content: String, date: Date) {
        self.title = title
        self.link = link
        self.summary = summary
        self.content = content
        self.date = date
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "HH:mm a, MMMM dd"
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        self.formattedDate = formatter.string(from: date)
    }

}
