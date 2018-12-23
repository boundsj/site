import Routing
import Vapor

var allPosts = [Post]()
var allPostsByLink = [String: Post]()

/// Called after your application has initialized.
///
/// [Learn More →](https://docs.vapor.codes/3.0/getting-started/structure/#bootswift)
public func boot(_ app: Application) throws {
    guard allPosts.count == 0 else { return }

    let dir = workingDir()
    let path = "\(dir)/Posts/"
    let enumerator = FileManager.default.enumerator(atPath: path)

    while let element = enumerator?.nextObject() as? String {
        let location = "\(dir)/Posts/\(element)"
        let fileContent = try! String(contentsOfFile: location)
        let frontMatter = FrontMatterUtils.extract(from: fileContent)
        let post = Post(title: frontMatter.title,
                        link: frontMatter.link,
                        summary: frontMatter.summary,
                        content: frontMatter.content)
        allPostsByLink[frontMatter.link!] = post
        allPosts.append(post)
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
