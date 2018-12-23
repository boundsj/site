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
        return leaf.render("index", ["posts": allPosts])
    }

    router.get("posts", String.parameter) { req -> Future<View> in
        let param = try req.parameters.next(String.self)
        let leaf = try req.make(LeafRenderer.self)

        guard let post = allPostsByLink[param] else {
            let context = [String]()
            return leaf.render("error", context)
        }

        let context: [String: String] = ["post": try markdownToHTML(post.content), "title": post.title]
        return leaf.render("post", context)
    }
}
