//
//  StackCalculator_Tests.swift
//  Service_Test_Tests
//
//  Created by Thomas Cherry on 2019-01-19.
//  Copyright © 2019 Thomas Cherry. All rights reserved.
//

import XCTest

class StackCalculator_Tests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testUnaryOps()
    {
        helper_test_math(equation: "3 p", expected: "3.000000")
        helper_test_math(equation: "2 ++ p", expected: "3.000000")
        helper_test_math(equation: "4 -- p", expected: "3.000000")
    }

    func testBinaryOps()
    {
        helper_test_math(equation: "1 2 + p", expected: "3.000000")
        helper_test_math(equation: "5 2 - p", expected: "3.000000")
        helper_test_math(equation: "2 3 * p", expected: "6.000000")
        helper_test_math(equation: "6 2 / p", expected: "3.000000")
        helper_test_math(equation: "5 2 % p", expected: "1.000000")
        helper_test_math(equation: "2 8 ^ p", expected: "256.000000")
    }

    func testTernaryOps()
    {
        helper_test_math(equation: "1 2 3 ?> p", expected: "2.000000")
        helper_test_math(equation: "-1 2 3 ?> p", expected: "3.000000")
        helper_test_math(equation: "1 2 3 4 5 6 7 8 9 avg p", expected: "5.000000")
    }
    
    func testHelpOps()
    {
        let stack = StackCalculator()
        let help = stack.help()
        print (help)
    }
    
    func helper_test_math(equation:String, expected:String)
    {
        let stack = StackCalculator()
        let ans = stack.calculate(equation)
        XCTAssertEqual(expected, ans)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
            helper_test_math(equation: "1 2 3 4 5 6 7 8 9 avg p", expected: "5.000000")
            
        }
    }

}
