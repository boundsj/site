import Routing
import Vapor
import Leaf
import SwiftMarkdown

/// Register your application's routes here.
///
/// [Learn More →](https://docs.vapor.codes/3.0/getting-started/structure/#routesswift)
public func routes(_ router: Router) throws {

    var allPosts = [String]()
    var postsByDate = [String: String]()
    var postPathByTitle = [String: String]()

    router.get("/") { req -> Future<View> in
        let leaf = try req.make(LeafRenderer.self)
        let context = [String: String]()
        return leaf.render("index", context)
    }

    router.get("posts") { req -> Future<View> in
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
        let context = ["posts": allPosts]
        let leaf = try req.make(LeafRenderer.self)
        return leaf.render("posts", context)
    }

    router.get("posts", String.parameter) { req -> Future<View> in
        let param = try req.parameters.next(String.self)
        let unescapedParam = param.removingPercentEncoding! // TODO: Fix this
        let postPath = postPathByTitle[unescapedParam]! // TODO: Fix this
        let leaf = try req.make(LeafRenderer.self)
        let dir = workingDir()
        let location = "\(dir)/Posts/\(postPath)"
        let fileContent = try! String(contentsOfFile: location)
        let context = ["post": try markdownToHTML(fileContent)]
        return leaf.render("post", context)
    }
}

public func workingDir() -> String {
    let fileBasedWorkDir: String?

    #if Xcode
    // attempt to find working directory through #file
    let file = #file
    fileBasedWorkDir = file.components(separatedBy: "/Sources").first
    #else
    fileBasedWorkDir = nil
    #endif

    let workDir: String
    if let fileBasedWorkDir = fileBasedWorkDir {
        workDir = fileBasedWorkDir
    } else {
        // get actual working directory
        let cwd = getcwd(nil, Int(PATH_MAX))
        defer {
            free(cwd)
        }
        if let cwd = cwd, let string = String(validatingUTF8: cwd) {
            workDir = string
        } else {
            workDir = "./"
        }
    }

    return workDir
}
