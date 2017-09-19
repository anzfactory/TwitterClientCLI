//
//  Shell.swift
//  TwitterClientCLI
//
//  Created by shingo asato on 2017/09/10.
//
//

import Foundation

struct Shell {
    static func run(path: String, args: [String]?) -> String? {
        let process = Process()
        process.launchPath = path
        if let args = args {
            process.arguments = args
        }
        let pipe = Pipe()
        process.standardOutput = pipe
        process.launch()
        process.waitUntilExit()
        return String(data: Data(pipe.fileHandleForReading.readDataToEndOfFile()), encoding: .utf8)
    }
}
