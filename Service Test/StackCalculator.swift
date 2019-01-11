//
//  StackCalculator.swift
//  Service Test
//
//  Created by Thomas Cherry on 2019-01-11.
//  Copyright © 2019 Thomas Cherry. All rights reserved.
//

import Foundation

/* ************************************************************************** */

/**
 Perform RPN calculations
 - Author:
 thomas cherry
 - Version:
 0.1
 */
class StackCalculator: NSObject
{
    /* ****************************************************************** */
    // MARK: - Globals
    
    //var stack = [CalculatorWord]()
    var stack = [Float64]()
    
    /* ****************************************************************** */
    // MARK: - Methods
    
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
    func calculate(_ formula:String) -> String
    {
        var ans: String = ""
        let clean = formula.trimmingCharacters(in: .whitespacesAndNewlines)
        let parts = clean.split(separator: " ")
        for item in parts
        {
            if let num = Float64(item)
            {
                stack.append(num)
                print (stack)
                continue
            }
            else
            {
                let cmd:String? = String(item)
                if (cmd != nil)
                {
                    switch cmd
                    {
                        case "p", "++", "--":
                            ans = unary(operation: cmd!)
                        case "+", "-", "*", "/", "%":
                            binary(operation: cmd!)
                        default:
                            ans = ""
                    }
                    continue
                }
            }
        }
        return ans;
    }
    
    // MARK: - Operation Types
    
    func unary(operation:String) -> String
    {
        var ans = ""
        switch operation
        {
            case "--": decrement()
            case "++": increment()
            case "p": ans = printTop()
            default:
                ans = ""
                print(stack)
        }
        return ans
    }

    func binary(operation:String)
    {
        switch operation
        {
            case "+": plus()
            case "-": minus()
            case "*": times()
            case "/": divide()
            case "%": modulo()
            default: print (stack)
        }
    }

    func ternary(operation:String)
    {
    }

    // MARK: - Operations

    func decrement()
    {
        if let value = stack.popLast()
        {
            let result = value-1
            stack.append(result)
        }
    }
    func increment()
    {
        if let value = stack.popLast()
        {
            let result = value+1
            stack.append(result)
        }
    }

    func printTop() -> String
    {
        var ans = ""
        if let last = stack.last
        {
            ans = String(format: "%f", last)
        }
        print("printing ans of \(ans)")
        return ans
    }
    
    func plus()
    {
        if let right = stack.popLast()
        {
            if let left = stack.popLast()
            {
                let result = left + right
                stack.append(result)
                print (stack)
                return
            }
            else
            {
                //throw error
            }
        }
        else
        {
            //throw an error
        }
    }
    func minus()
    {
        if let right = stack.popLast()
        {
            if let left = stack.popLast()
            {
                let result = left - right
                stack.append(result)
                print (stack)
            }
        }
    }

    func times()
    {
        if let right = stack.popLast()
        {
            if let left = stack.popLast()
            {
                    let result = left * right
                stack.append(result)
                print (stack)
            }
        }
    }

    func divide()
    {
        if let right = stack.popLast()
        {
            if let left = stack.popLast()
            {
                let result = left / right
                stack.append(result)
                print (stack)
            }
        }
    }

    func modulo()
    {
        if let right = stack.popLast()
        {
            if let left = stack.popLast()
            {
                let result = left.truncatingRemainder(dividingBy: right)
                stack.append(result)
                print (stack)
            }
        }
    }


}
