//
//  ServiceCmr.swift
//  Service Test
//
//  Created by Thomas Cherry on 2019-01-04.
//  Copyright © 2019 Thomas Cherry. All rights reserved.
//

import Foundation
import AppKit

/**
 handle requests from the service menu using the swift language
 - Author:
 thomas cherry
 - Version:
 0.1
 */
@objcMembers class ServiceCmr: NSObject
{
    /* ********************************************************************** */
    // MARK: - service handlers
    
    var calculator:StackCalculator?
    
    /**
    Could never get this function to work, don't know why the OS will not
    recognize the function signature, leaving it here till it is figured out
    what is wrong.
    
    * Parameters:
        * pboard: the pasteboard to read and write to
        * userData: associated user data that goes with the pasteboard
        * error: nil if no errors, message otherwise
    */
    func convertCollectionId(
        _ pboard: NSPasteboard?
        , userData:String
        , error:AutoreleasingUnsafeMutablePointer<NSString>)
    {
        if (pboard?.canReadObject(forClasses: [NSString.self], options: Dictionary()))!
        {
            let x = pboard?.readObjects(forClasses: [NSString.self], options: nil)
            let s = x?.first as! String
            let ans = router(action: "prefix", source: s)
            
            pboard?.clearContents()
            pboard?.writeObjects([ans as! NSPasteboardWriting])
        }
    }
    
    /**
     execute the requested macro
     * Parameters:
        * action: enum of the action to perform
        * source: text to be operated on
     * Returns:
    the operated on text
     * Version:
        0.1
     */
    func router(action:String, source:String) -> Dictionary<String, String>
    {
        var ret = ["text/plain": "", "text/html": ""]
        switch action
        {
            case "rpn":
                ret = calculate(formula: source)
            case "prefix1":
                ret = prefix1(src: source);
            case "prefix2":
                ret = prefix2(src: source);
            case "lower":
                ret = self.lowercase(src: source)
            case "upper":
                ret = self.uppercase(src: source)
            case "markdown":
                ret = self.markdown(text: source)
            default:
                print("unknown action")
        }
        return ret
    }
    
    func markdown_shell(text:String) -> String
    {
        let defaults = UserDefaults.standard;
        let cmd = defaults.string(forKey: "markdown.cmd") ?? "/usr/local/bin/markdown"
        let out = shell(launchPath: cmd, arguments: [], raw: text)
        return out
    }

    func shell(launchPath: String, arguments: [String], raw:String) -> String
    {
        print ("warning: running \(launchPath)")
        let task = Process()
        task.launchPath = launchPath
        task.arguments = arguments

        let pipe_in = Pipe()
        task.standardInput = pipe_in
        
        let pipe_out = Pipe()
        task.standardOutput = pipe_out
        
        task.launch()

        //send document
        let data_in = raw.data(using: .utf8)
        pipe_in.fileHandleForWriting.write(data_in!)
        pipe_in.fileHandleForWriting.closeFile()

        task.waitUntilExit()
        
        //read document
        let data = pipe_out.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)!

        task.terminate()
        return output
    }
    
    /* ********************************************************************** */
    // MARK: - actions
    
    /**
     change the selected text to upper case
     * Parameters:
        - src: text to change
     * Returns:
        all text is uppercases
     */
    func uppercase(src:String) -> Dictionary<String,String>
    {
        return ["text/plain":src.uppercased(), "text/html":""]
    }
    
    func lowercase(src:String) -> Dictionary<String,String>
    {
        return ["text/plain":src.lowercased(), "text/html":""]
    }
    
    func markdown(text:String) -> Dictionary<String,String>
    {
        //call the markdown command, get it converted
        //let markdown = "<h1>Markdown</h1>\n<b>bold</b> <i>italic</i> <u>underline</u>"
        let markdown = markdown_shell(text: text)
        return ["text/plain":text, "text/html":markdown]
    }
    
    func calculate(formula:String) -> Dictionary<String,String>
    {
        if self.calculator==nil
        {
            self.calculator = StackCalculator()
        }
        let result:String = (calculator?.calculate(formula))!
        let output = String("\(formula) = \(result)")
        return ["text/plain":output, "text/html":""]
    }
    
    //curl "https://cmr.sit.earthdata.nasa.gov/search/concepts/C1200210916-SCIOPSTEST"
    func prefix1(src:String) -> Dictionary<String,String>
    {
        return generic_prefix(src: src
            , pattern: "url.pattern.1"
            , patternDefault: "[a-z]?[0-9]*-[a-zA-Z_]+"
            , prefix: "url.prefix.1"
            , prefixDefault: "https://cmr.earthdata.nasa.gov/search/concepts/"
        )
    }

    //curl "https://bugs.earthdata.nasa.gov/browse/GCMD-1234"
    func prefix2(src:String) -> Dictionary<String,String>
    {
        return generic_prefix(src: src
            , pattern: "url.pattern.2"
            , patternDefault: "[A-Z]+-[0-9]+"
            , prefix:"url.prefix.2"
            , prefixDefault: "https://bugs.earthdata.nasa.gov/browse/"
        )
    }
    
    func generic_prefix(src:String
            , pattern:String, patternDefault:String
            , prefix:String, prefixDefault:String
    ) -> Dictionary<String,String>
    {
        let defaults = UserDefaults.standard;
        let pattern = defaults.string(forKey: pattern) ?? patternDefault
        let host = defaults.string(forKey: prefix) ?? patternDefault
        let range = NSRange(location:0, length:src.utf8.count)
        let regex = try! NSRegularExpression(pattern: pattern)
        var text_link = src
        if regex.firstMatch(in: src, options: [], range: range) != nil
        {
            text_link = host + src
        }
        let html_link = String(format: "<a href=\"%s\">%s</a>", text_link)
        
        return ["text/plain":text_link, "text/html":html_link]
    }

}
