//
//  ActionHandler_tests.swift
//  Service_Test_Tests
//
//  Created by Thomas Cherry on 2019-01-20.
//  Copyright © 2019 Thomas Cherry. All rights reserved.
//

import XCTest

class ActionHandler_tests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testLowerCase()
    {
        let handler:ActionHandler = ActionHandler()
        let input = "The Quick Brown Fox Jumps Over the Lazy Dogs"
        let result = handler.router(action: "lower", source: input)
        let expected = "the quick brown fox jumps over the lazy dogs"
        XCTAssertEqual(result["text/plain"], expected)
    }

    func testUpperCase()
    {
        let handler:ActionHandler = ActionHandler()
        let input = "The Quick Brown Fox Jumps Over the Lazy Dogs"
        let result = handler.router(action: "upper", source: input)
        let expected = "THE QUICK BROWN FOX JUMPS OVER THE LAZY DOGS"
        XCTAssertEqual(result["text/plain"], expected)
    }
    /*
            case "replacement": ret = self.regexConvert(src: source)
    */
    
    func testReplace()
    {
        let handler:ActionHandler = ActionHandler()
        let ans = handler.regexConvert(src:"C1234-provider")
        print (ans)
    }
    
    func testRPN()
    {
        let handler:ActionHandler = ActionHandler()
        let input = "5 4 3 2 1 + * - / ="
        let result = handler.router(action: "rpn", source: input)
        let expected = "5 4 3 2 1 + * - / = is -1.000000"
        XCTAssertEqual(result["text/plain"], expected)
    }

    func testMarkdown()
    {
        let handler:ActionHandler = ActionHandler()
        let input = "# Header #\n* one"
        let result = handler.router(action: "markdown", source: input)
        let expected = "<h1>Header</h1>\n\n<ul>\n<li>one</li>\n</ul>\n\n"
        XCTAssertEqual(result["text/plain"], input)
        XCTAssertEqual(result["text/html"], expected)
    }
    func testExecute()
    {
        let handler:ActionHandler = ActionHandler()
        let input = "#!/bin/bash -S --\necho 'hi'"
        let result = handler.router(action: "execute", source: input)
        let expected = "#!/bin/bash -S --\necho \'hi\'\n---- ---- ---- ----\nhi\n\n---- ---- ---- ----\n"
        XCTAssertEqual(result["text/plain"], expected)
        XCTAssertEqual(result["text/html"], "")
    }
    
    func testClipboardStack()
    {
        let handler:ActionHandler = ActionHandler()
        let first = "one"
        let second = "two"
        let result1 = handler.router(action: "cpush", source: first)
        let result2 = handler.router(action: "cpush", source: second)
        let result3 = handler.router(action: "cpop", source: "replace me")
        let result4 = handler.router(action: "cpop", source: "replace me")
        
        XCTAssertEqual(result1["text/plain"], "")
        XCTAssertEqual(result2["text/plain"], "")
        XCTAssertEqual(result3["text/plain"], second)
        XCTAssertEqual(result4["text/plain"], first)
        XCTAssertEqual(result1["text/html"], "")
        XCTAssertEqual(result2["text/html"], "")
        XCTAssertEqual(result3["text/html"], "")
        XCTAssertEqual(result4["text/html"], "")
    }

    func testPerformanceExample()
    {
        // This is an example of a performance test case.
        self.measure
        {
            testRPN()
        }
    }

}
