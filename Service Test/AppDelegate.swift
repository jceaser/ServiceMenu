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
        process(arguments: ProcessInfo.processInfo.arguments)
    }

    func applicationWillTerminate(_ aNotification: Notification)
    {
        // Insert code here to tear down your application
    }

    func process(arguments:[String])
    {
        var command = ""
        var input = ""
        
        for i in 0...arguments.count-1
        {
            let arg = arguments[i]
            let opt = i<arguments.count-1 ? arguments[i+1] : ""
            let opt_exists = !opt.isEmpty
            
            switch arg
            {
                case "-c", "--command":
                    if opt_exists
                    {
                        command = opt
                    }
                case "-i", "--input":
                    if opt_exists
                    {
                        input = opt
                    }
                default:
                    nop()
            }
        }
        
        if !command.isEmpty && !input.isEmpty
        {
            switch command
            {
                case "calculator", "cal":
                    let calculator = StackCalculator()
                    let result = calculator.calculate(input)
                    print ("result=\(result)")
                    exit(0)
                default:
                    print("unkown command")
            }
        }
    }
    func nop(){}
}

