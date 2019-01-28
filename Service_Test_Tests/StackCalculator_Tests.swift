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
        helper_test_math(equation: "3 =", expected: "3.000000")
        helper_test_math(equation: "3 dump", expected: "[3.0]")

        helper_test_math(equation: "2 ++ =", expected: "3.000000")
        helper_test_math(equation: "4 -- =", expected: "3.000000")
        
        helper_test_math(equation: "1 2 3 4 5 << << dump", expected: "[3.0, 4.0, 5.0, 1.0, 2.0]")
        helper_test_math(equation: "1 2 3 4 5 >> >> dump", expected: "[4.0, 5.0, 1.0, 2.0, 3.0]")
        
        helper_test_math(equation: "5 ^2 =", expected: "25.000000")
        helper_test_math(equation: "25 √ =", expected: "5.000000")
        
        helper_test_math(equation: "-128 abs Print", expected: "128")
        
        helper_test_math(equation: "π =", expected: "3.141593")
        helper_test_math(equation: "SoL =", expected: "299792458.000000")

        helper_test_math(equation: "-128.9 floor Print", expected: "-129")
        helper_test_math(equation: "128.9 floor Print", expected: "128")
        helper_test_math(equation: "-128.9 ceil Print", expected: "-128")
        helper_test_math(equation: "128.9 ceil Print", expected: "129")
    }

    func testBinaryOps()
    {
        helper_test_math(equation: "1 2 + =", expected: "3.000000")
        helper_test_math(equation: "5 2 - =", expected: "3.000000")
        helper_test_math(equation: "2 3 * =", expected: "6.000000")
        helper_test_math(equation: "6 2 / =", expected: "3.000000")
        helper_test_math(equation: "5 2 % =", expected: "1.000000")
        helper_test_math(equation: "2 8 ^ =", expected: "256.000000")
        helper_test_math(equation: "1 2 3 <> dump", expected: "[1.0, 3.0, 2.0]")
        helper_test_math(equation: "1 2 max =", expected: "2.000000")
        helper_test_math(equation: "1 2 min =", expected: "1.000000")
    }

    func testTernaryOps()
    {
        helper_test_math(equation: "1 2 3 ?> =", expected: "2.000000")
        helper_test_math(equation: "0 2 3 ?> =", expected: "3.000000")
        helper_test_math(equation: "-1 2 3 ?> =", expected: "3.000000")
        helper_test_math(equation: "1 2 3 4 5 6 7 8 9 avg =", expected: "5.000000")
        helper_test_math(equation: "1 2 3 4 5 6 7 8 clear dump", expected: "[]")
    }
    
    func testPrintOutput()
    {
        helper_test_math(equation: "2 16 ^ =", expected: "65536.000000")
        helper_test_math(equation: "2 16 ^ = 2 32 ^ =", expected: "65536.000000 4294967296.000000")
        helper_test_math(equation: "2 16 ^ Print", expected: "65,536")
        helper_test_math(equation: "2.0 16.0 ^ Print", expected: "65,536")
        helper_test_math(equation: "2 16 ^ 3 / Print", expected: "21,845.333")
        helper_test_math(equation: "1 2 3 4 5 dump", expected: "[1.0, 2.0, 3.0, 4.0, 5.0]")
        helper_test_math(equation: "1 2 3 dump 4 5 6 dump", expected: "[1.0, 2.0, 3.0] [1.0, 2.0, 3.0, 4.0, 5.0, 6.0]")
    }
    
    func testMultiply()
    {
        helper_test_math(equation: "1 2 3 4 5 6 7 8 9 +:8 =", expected: "45.000000")
    }
    
    func testOtherOperations()
    {
        helper_test_math(equation: "3 ^2 4 ^2 + √ =", expected: "5.000000")
    }
    
    func testMemoryOperations()
    {
        helper_test_math(equation: "2 3 4 A * + a - dump", expected: "[10.0]")
        helper_test_math(equation: "2 A 3 B 4 C c a * b - dump", expected: "[2.0, 3.0, 4.0, 5.0]")
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
            helper_test_math(equation: "1 2 3 4 5 6 7 8 9 avg =", expected: "5.000000")
            
        }
    }

}
