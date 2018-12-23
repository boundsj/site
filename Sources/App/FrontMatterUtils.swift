//
//  FrontMatterUtils.swift
//  App
//
//  Created by Jesse Bounds on 12/22/18.
//

import Foundation

struct FrontMatter {
    let title: String?
    let summary: String?
    let date: Date?
    let content: String?
    let link: String?
}

class FrontMatterUtils {

    static func extract(from markdown: String) -> FrontMatter {
        var title: String?
        var date: Date?
        var summary: String?
        let frontMatter = markdown.slice(from: "---", to: "---")?.split(separator: "\n")
        let content = markdown.removeSlice(from: "---", to: "---")?.trimLeft()

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

        // TODO: Posts with no title should be ignored

        let link = title?.split(separator: " ").map { $0.lowercased() }.joined(separator: "-")

        return FrontMatter(title: title,
                           summary: summary,
                           date: date,
                           content: content,
                           link: link)
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

    func removeSlice(from: String, to: String) -> String? {
        let lastIndex = self.range(of: "---", options: .backwards)!.upperBound
        let range = self.index(after: lastIndex)..<self.endIndex
        return String(self[range])
    }

    func trimLeft() -> String {
        var newString = self
        while newString.hasPrefix("\n") {
            newString = String(newString.dropFirst())
        }
        return newString
    }

}
