import Routing
import Vapor
import Leaf
import SwiftMarkdown

/// Register your application's routes here.
///
/// [Learn More →](https://docs.vapor.codes/3.0/getting-started/structure/#routesswift)
public func routes(_ router: Router) throws {

    router.get("/") { req -> Future<View> in
        let leaf = try req.make(LeafRenderer.self)
        let context = [String: String]()
        return leaf.render("index", context)
    }

    router.get("posts") { req -> Future<View> in
        let leaf = try req.make(LeafRenderer.self)
        let dir = workingDir()
        let location = NSString(string: "\(dir)/Posts/test.md").expandingTildeInPath
        let fileContent = try! String(contentsOfFile: location)
        let context = ["md": try markdownToHTML(fileContent)]
        return leaf.render("md", context)
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
