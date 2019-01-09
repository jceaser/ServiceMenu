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

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        //NSUnregisterServicesProvider(NSServiceProviderName(rawValue: "cmr collections"))
        NSUnregisterServicesProvider(NSServiceProviderName(rawValue: "CmrCollections"))
        
        //let sc = ServiceCmr()
        //NSRegisterServicesProvider(sc, NSServiceProviderName(rawValue: "cmr collections"))
        //NSRegisterServicesProvider(sc, NSServiceProviderName(rawValue: "CmrCollections"))
        //NSApplication.shared.servicesProvider = ServiceCmr()
        
        NSApplication.shared.servicesProvider = CmrCollections.init()
        NSUpdateDynamicServices()
        
    }

    func applicationWillTerminate(_ aNotification: Notification)
    {
        // Insert code here to tear down your application
    }

}

