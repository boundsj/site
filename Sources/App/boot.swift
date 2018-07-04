import Routing
import Vapor

var allPosts = [String]()
var postsByDate = [String: String]()
var postPathByTitle = [String: String]()

/// Called after your application has initialized.
///
/// [Learn More →](https://docs.vapor.codes/3.0/getting-started/structure/#bootswift)
public func boot(_ app: Application) throws {
    if allPosts.count == 0 {
        let dir = workingDir()
        let path = "\(dir)/Posts/"
        let enumerator = FileManager.default.enumerator(atPath: path)
        while let element = enumerator?.nextObject() as? String {
            let dateString = String(element.prefix(8))
            let elementWithNoDateString = element.replacingOccurrences(of: "\(dateString)_", with: "")
            let elementWithNoExtension = elementWithNoDateString.replacingOccurrences(of: ".md", with: "")
            let components = elementWithNoExtension.components(separatedBy: "_")
            let postTitle = components.joined(separator: " ")
            allPosts.append(postTitle)
            postsByDate[dateString] = postTitle
            postPathByTitle[postTitle] = element
        }
    }
}
