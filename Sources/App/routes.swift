import Routing
import Vapor
import Leaf
import SwiftMarkdown

struct Post: Codable {
    var title: String
    var link: String
    var summary: String?
}

/// Register your application's routes here.
///
/// [Learn More →](https://docs.vapor.codes/3.0/getting-started/structure/#routesswift)
public func routes(_ router: Router) throws {

    router.get("/") { req -> Future<View> in
        var posts = [Post]()
        for (spaced, dashed) in allPostsZipped {
            let frontMatter = frontMatterByDashedTitle[dashed]!
            let post = Post(title: spaced,
                            link: dashed,
                            summary: frontMatter.summary)
            posts.append(post)
        }
        let leaf = try req.make(LeafRenderer.self)
        return leaf.render("index", ["posts": posts])
    }

    router.get("posts", String.parameter) { req -> Future<View> in
        let param = try req.parameters.next(String.self)
        let leaf = try req.make(LeafRenderer.self)

        guard let postPath = postPathByTitle[param] else {
            let context = [String]()
            return leaf.render("error", context)
        }

        let dir = workingDir()
        let location = "\(dir)/Posts/\(postPath)"
        let fileContent = try! String(contentsOfFile: location)
        let title = postTitleByDashedTitle[param] ?? param
        let context: [String: String] = ["post": try markdownToHTML(fileContent), "title": title]
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
