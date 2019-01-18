//
//  ActionHandler.swift
//  Service Test
//
//  Created by Thomas Cherry on 2019-01-04.
//  Copyright © 2019 Thomas Cherry. All rights reserved.
//

import Foundation
import AppKit

    extension String {
    func substring(with nsrange: NSRange) -> Substring? {
        guard let range = Range(nsrange, in: self) else { return nil }
        return self[range]
    }
}

/**
 handle requests from the service menu using the swift language
 - Author:
 thomas cherry
 - Version:
 0.1
 */
@objcMembers class ActionHandler: NSObject
{
    /* ********************************************************************** */
    // MARK: - globals
    
    var calculator:StackCalculator?
    var clipboardStack = Array<String>()
    
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
    public func router(action:String, source:String) -> Dictionary<String, String>
    {
        var ret = ["text/plain": "", "text/html": ""]
        switch action
        {
            case "cpush": clipboardStackPush(src: source)
            case "cpop": ret = self.clipboardStackPop(src: source)
            case "execute": ret = self.execute(src: source)
            case "rpn": ret = self.calculate(formula: source)
            case "replacement": ret = self.regexConvert(src: source)
            case "lower": ret = self.lowercase(src: source)
            case "upper": ret = self.uppercase(src: source)
            case "markdown": ret = self.markdown(text: source)
            default:
                print("unknown action")
        }
        return ret
    }
    
    /* ********************************************************************** */
    // MARK: - service handlers

    /**
    Could never get this function to work, don't know why the OS will not
    recognize the function signature, leaving it here till it is figured out
    what is wrong.
    
    * Parameters:
        * pboard: the pasteboard to read and write to
        * userData: associated user data that goes with the pasteboard
        * error: nil if no errors, message otherwise
    */
    func test_action(
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
    
    /* ********************************************************************** */
    // MARK: - actions
    
    func clipboardStackPush(src:String) // -> Dictionary<String,String>
    {
        self.clipboardStack.append(src);
        //return ["text/plain":"", "text/html":""]
    }
    
    func clipboardStackPop(src:String) -> Dictionary<String,String>
    {
        var ret = ""
        if let item = self.clipboardStack.popLast()
        {
            ret = item
        }
        return ["text/plain":ret, "text/html":""]
    }

    func execute(src:String) -> Dictionary<String,String>
    {
        let lines = src.components(separatedBy: "\n")
        var ret = src
        if let first:String = lines.first
        {
            //let defaults = UserDefaults.standard;
            var cmd = "/bin/bash"
            //cmd = "/usr/bin/env"
            var opt = ""
            /*
            if (first=="#!/usr/bin/env ruby")
            {
                //cmd = defaults.string(forKey: "exec.ruby") ?? "/usr/bin/ruby"
                opt = "ruby"
            }
            else if (first=="#!/usr/bin/env python")
            {
                //cmd = defaults.string(forKey: "exec.python") ?? "/usr/bin/python"
                opt = "pypthon"
            }
            */
            let parts = first.components(separatedBy: " ")
            if let first_cmd = parts.first
            {
                if let last_cmd = parts.last
                {
                    //var cmd_part = first_cmd
                    cmd = String(first_cmd.dropFirst(2))
                    print (cmd)
                    opt = last_cmd
                }
            }
            
            let out = shell(launchPath: cmd, arguments: [opt], raw: src) //"2>&1"
            ret = "\(src)\n---- ---- ---- ----\n\(out)\n---- ---- ---- ----\n"
        }
        return ["text/plain":ret, "text/html":""]
    }
    
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
    
    func regexConvert(src:String) -> Dictionary<String,String>
    {
        //[ {r: regular Expression, f:format } ]
        let default_obj = "{\"r\":\"%@\", \"f\":\"%@\"}"
        let default_one = String(format:default_obj, "([a-zA-Z]?[0-9]*-[a-zA-Z_-]+)", "https://cmr.earthdata.nasa.gov/search/concepts/%@?pretty=true")
        let default_two = String(format:default_obj, "([A-Z]+-[0-9]+)", "https://bugs.earthdata.nasa.gov/browse/%@")
        let default_data = String(format:"[%@, %@]", default_one, default_two)
        print ("\n****\n\(default_data)\n****\n")
        
        let defaults = UserDefaults.standard;
        let raw_data = defaults.string(forKey: "convert.data") ?? default_data
        
        var out = src
        
        if let data = raw_data.data(using: String.Encoding.utf8)
        {
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) as! [Any]
            {
                for i in json
                {
                    let row = i as! [String:Any]
                    if let format = row["f"] as! String?
                    {
                        if let regular = row["r"] as! String?
                        {
                            out = search(source: out, with:regular, replace:format)
                        }
                    }
                }
            }
        }
        return ["text/plain":out, "text/html":""]
    }
    
    /* ********************************************************************** */
    // MARK: - helpers

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

    /**
     Search for patterns in a string and replace them
     * Parameters:
        * source: text to search through
        * with: RegExp of the text to find, this should include a group '()'
        * replace: a printf style format with %@ positioned where group shoud go
     * Returns:
     the operated on text
     * Version:
        0.1
     */
    func search(source:String, with:String, replace:String) -> String
    {
        let range = NSRange(location:0, length:source.utf16.count)
        let regex = try! NSRegularExpression(pattern: with)
        let matches = regex.matches(in: source, options: [], range: range)
        
        var out = source
        for r in matches
        {
            if let found = source.substring(with: r.range)
            {
                let url = String(format:replace, String(found))
                out = out.replacingOccurrences(of: found, with: url, options: String.CompareOptions.caseInsensitive, range: nil)
            }
        }
        return out
    }
}
