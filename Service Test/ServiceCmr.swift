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
 handle requests from the service menu
 - Author:
 thomas cherry
 - Version:
 0.1
 */
@objcMembers class ServiceCmr: NSObject
{
    /* ********************************************************************** */
    // MARK: - service handlers
    
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
            pboard?.writeObjects([ans as NSPasteboardWriting])
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
    func router(action:String, source:String) -> String
    {
        var ans = ""
        switch action
        {
            case "rpn":
                ans = calculate(formula: source)
            case "prefix":
                ans = prefix(src: source);
            case "lower":
                ans = source.lowercased()
            case "upper":
                ans = self.uppercase(src: source)
            default:
                ans = "No action"
        }
        return ans
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
    func uppercase(src:String) -> String
    {
        return src.uppercased();
    }
    
    func markdown(text:String) -> String
    {
        //call the markdown command, get it converted
        
        return ""
    }
    
    func calculate(formula:String) -> String
    {
        let calculator = StackCalculator()
        return calculator.calculate(formula)
    }
    
    //curl "https://cmr.sit.earthdata.nasa.gov/search/concepts/C1200210916-SCIOPSTEST"
    func prefix(src:String) -> String
    {
        let defaults = UserDefaults.standard;
        let pattern = defaults.string(forKey: "url.pattern.1") ??
            "[a-z]?[0-9]*-[a-zA-Z_]+"
        let host = defaults.string(forKey: "url.prefix.1") ??
            "https://cmr.earthdata.nasa.gov/search/concepts/"
        let range = NSRange(location:0, length:src.utf16.count)
        let regex = try! NSRegularExpression(pattern: pattern)
        var ret = src
        if regex.firstMatch(in: src, options: [], range: range) != nil
        {
            ret = host + src
        }
        return ret
    }

    //curl "https://bugs.earthdata.nasa.gov/browse/GCMD-1234"
    func prefix2(src:String) -> String
    {
        let defaults = UserDefaults.standard;
        let pattern = defaults.string(forKey: "url.pattern.2") ??
            "[A-Z]+-[0-9]+"
        let host = defaults.string(forKey: "url.prefix.2") ??
            "https://bugs.earthdata.nasa.gov/browse/"
        let range = NSRange(location:0, length:src.utf16.count)
        let regex = try! NSRegularExpression(pattern: pattern)
        var ret = src
        if regex.firstMatch(in: src, options: [], range: range) != nil
        {
            ret = host + src
        }
        return ret
    }

}
