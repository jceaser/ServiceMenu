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
        helper_test_math(equation: "3 d", expected: "[3.0]")

        helper_test_math(equation: "2 ++ p", expected: "3.000000")
        helper_test_math(equation: "4 -- p", expected: "3.000000")
        
        helper_test_math(equation: "1 2 3 4 5 << << d", expected: "[3.0, 4.0, 5.0, 1.0, 2.0]")
        helper_test_math(equation: "1 2 3 4 5 >> >> d", expected: "[4.0, 5.0, 1.0, 2.0, 3.0]")
        
        helper_test_math(equation: "5 ^2 p", expected: "25.000000")
        helper_test_math(equation: "25 √ p", expected: "5.000000")
        
        helper_test_math(equation: "-128 abs P", expected: "128")
        
        helper_test_math(equation: "π p", expected: "3.141593")
        helper_test_math(equation: "c p", expected: "299792458.000000")

        helper_test_math(equation: "-128.9 floor P", expected: "-129")
        helper_test_math(equation: "128.9 floor P", expected: "128")
        helper_test_math(equation: "-128.9 ceil P", expected: "-128")
        helper_test_math(equation: "128.9 ceil P", expected: "129")
    }

    func testBinaryOps()
    {
        helper_test_math(equation: "1 2 + p", expected: "3.000000")
        helper_test_math(equation: "5 2 - p", expected: "3.000000")
        helper_test_math(equation: "2 3 * p", expected: "6.000000")
        helper_test_math(equation: "6 2 / p", expected: "3.000000")
        helper_test_math(equation: "5 2 % p", expected: "1.000000")
        helper_test_math(equation: "2 8 ^ p", expected: "256.000000")
        helper_test_math(equation: "1 2 3 <> d", expected: "[1.0, 3.0, 2.0]")
        helper_test_math(equation: "1 2 max p", expected: "2.000000")
        helper_test_math(equation: "1 2 min p", expected: "1.000000")
    }

    func testTernaryOps()
    {
        helper_test_math(equation: "1 2 3 ?> p", expected: "2.000000")
        helper_test_math(equation: "0 2 3 ?> p", expected: "3.000000")
        helper_test_math(equation: "-1 2 3 ?> p", expected: "3.000000")
        helper_test_math(equation: "1 2 3 4 5 6 7 8 9 avg p", expected: "5.000000")
    }
    
    func testPrintOutput()
    {
        helper_test_math(equation: "2 16 ^ =", expected: "65536.000000")
        helper_test_math(equation: "2 16 ^ p", expected: "65536.000000")
        helper_test_math(equation: "2 16 ^ P", expected: "65,536")
        helper_test_math(equation: "2.0 16.0 ^ P", expected: "65,536")
        helper_test_math(equation: "2 16 ^ 3 / P", expected: "21,845.333")
        helper_test_math(equation: "1 2 3 4 5 d", expected: "[1.0, 2.0, 3.0, 4.0, 5.0]")
    }
    
    func testMultiply()
    {
        helper_test_math(equation: "1 2 3 4 5 6 7 8 9 +:8 p", expected: "45.000000")
    }
    
    func testOtherOperations()
    {
        helper_test_math(equation: "3 ^2 4 ^2 + √ p", expected: "5.000000")
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
