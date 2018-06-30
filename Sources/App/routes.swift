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

    router.get("md") { req -> Future<View> in
        let leaf = try req.make(LeafRenderer.self)
        let test_md = "# Hello"
        let context = ["md": try markdownToHTML(test_md)]
        return leaf.render("md", context)
    }
}
