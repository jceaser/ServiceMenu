//
//  AppDelegate.swift
//  Service Test
//
//  Created by Thomas Cherry on 2019-01-02.
//  Copyright © 2019 Thomas Cherry. All rights reserved.
//

import Cocoa

@NSApplicationMain

/**
 - Author:
 thomas cherry
 - Version:
 0.1
 */
class AppDelegate: NSObject, NSApplicationDelegate
{
    @IBOutlet weak var window: NSWindow!
    
    //launch with: /Applications/TextEdit.app/Contents/MacOS/TextEdit -NSDebugServices com.cherry.thomas.Service-Test
    // reset with: /System/Library/CoreServices/pbs -update
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        NSUnregisterServicesProvider(NSServiceProviderName(rawValue: "ServiceHandler"))
        
        NSApplication.shared.servicesProvider = ServiceHandler.init()
        NSUpdateDynamicServices()
    }

    func applicationWillTerminate(_ aNotification: Notification)
    {
        // Insert code here to tear down your application
    }

}

