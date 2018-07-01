import Foundation

extension FileManager {

    class public func workingDir() -> String {
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

}
