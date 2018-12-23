//
//  FrontMatterUtils.swift
//  App
//
//  Created by Jesse Bounds on 12/22/18.
//

import Foundation

struct FrontMatter {
    let title: String?
    let date: Date?
    let summary: String?
}

class FrontMatterUtils {

    static func extract(from content: String) -> FrontMatter {
        var title: String?
        var date: Date?
        var summary: String?
        let frontMatter = content.slice(from: "---", to: "---")?.split(separator: "\n")

        for line in frontMatter ?? [] {
            let keyVal = String(line).split(separator: ":", maxSplits: 1).map { String($0).trimmingCharacters(in: .whitespaces) }

            if keyVal[0] == "title" {
                title = keyVal[1]
            }
            if keyVal[0] == "summary" {
                summary = keyVal[1]
            }
            if keyVal[0] == "date" {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                date = dateFormatter.date(from: keyVal[1])
            }
        }

        return FrontMatter(title: title, date: date, summary: summary)
    }

}

extension String {

    func slice(from: String, to: String) -> String? {
        return (range(of: from)?.upperBound).flatMap { substringFrom in
            (range(of: to, range: substringFrom..<endIndex)?.lowerBound).map { substringTo in
                String(self[substringFrom..<substringTo])
            }
        }
    }

}
