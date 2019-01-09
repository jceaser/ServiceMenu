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
            let ans = router(action: "upper", source: s)
            
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

}
