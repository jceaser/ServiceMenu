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
    
    /**
    Math stack, this contains the entire stack for all RPN calculations
    */
    var stack = [Float64]()
    
    /* ****************************************************************** */
    // MARK: - Methods
    
    /**
     calculate an RPN formula
     * Parameters:
        * formula: a RPN formula such as "2 3 * P"
     * Returns:
     the answer to the formula
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
                        case "help": ans = help()
                        case "=", "p", "++", "--":
                            ans = self.unary(operation: cmd!)
                        case "+", "-", "*", "/", "%", "^":
                            self.binary(operation: cmd!)
                        case "?>", "avg":
                            self.ternary(operation: cmd!)
                        default:
                            ans = ""
                    }
                    print (stack)
                    continue
                }
            }
        }
        return ans;
    }
    
    // MARK: - Operation Types
    
    /**
    Processes all the operations that are unary in nature ; operations on the
    top most item on the stack
    
    * Parameter operation: name/symble of the operation to perform
    * Returns:
    in most cases, an empty string as there is nothing to print out
    */
    func unary(operation:String) -> String
    {
        var ans = ""
        switch operation
        {
            case "--": decrement()
            case "++": increment()
            case "p", "=": ans = printTop()
            default:
                ans = ""
                print(stack)
        }
        return ans
    }

    /**
    Processes all the operations that are binary in nature ; operations on the
    top two items on the stack
    
    * Parameter operation: name/symble of the operation to perform
    * Returns:
    in most cases, an empty string as there is nothing to print out
    */
    func binary(operation:String)
    {
        switch operation
        {
            case "+": plus()
            case "-": minus()
            case "*": times()
            case "/": divide()
            case "%": modulo()
            case "^": power()
            default: print (stack)
        }
    }

    /**
    Processes all the operations that are ternary in nature ; operations on the
    top three item on the stack
    
    * Parameter operation: name/symble of the operation to perform
    * Returns:
    in most cases, an empty string as there is nothing to print out
    */
    func ternary(operation:String)
    {
        switch operation
        {
            case "?>": if_positive()
            case "avg": average()
            default: print (stack)
        }
    }

    func help() -> String
    {
        var out = ""
        let format = "%-5@ : %-10@ [%@]->[%@] - %@\n"
        out = out + String(format: format, "opt", "Operation", "In", "Out", "Description")
        out = out + String(format: format, "-----", "----------", "--", "---", "-----------")
        out = out + String(format: format, "avg", "average", "all", "1", "Takes the average of the entire stack")
        out = out + String(format: format, "++", "increment", "1", "1" , "adds one to top of stack")
        out = out + String(format: format, "--", "decrement", "1", "1" , "Subtracts one from top of stack")
        out = out + String(format: format, "p", "print", "1", "-", "Prints top of stack")
        out = out + String(format: format, "+", "add", "2", "1", "adds top two stack items and returns to top of stack")
        out = out + String(format: format, "-", "subtract", "2", "1", "subtracts top two stack items")
        out = out + String(format: format, "*", "multiply", "2", "1", "mulitpiles top two stack items")
        out = out + String(format: format, "/", "divide", "2", "1", "mulitpiles top two stack items")
        out = out + String(format: format, "%", "modis", "2", "1", "divides top two and returns remander")
        out = out + String(format: format, "^", "power", "2", "1", "takes power of top two stack items")
        out = out + String(format: format, "if>", "if positive", "3", "1", "if [0]>0 then return [1], else [2]")

        return out
    }

    // MARK: - Operations
    
    func average()
    {
        let max = stack.count
        var running = 0.0
        for _ in 1...max
        {
            if let popped = stack.popLast()
            {
                running = running + popped
            }
        }
        let ans = running / Float64(max)
        stack.append(ans)
    }
    
    /**
    Decrement the top static item by 1.0
    */
    func decrement()
    {
        if let value = stack.popLast()
        {
            let result = value-1
            stack.append(result)
        }
    }
    /**
    incrument the top static item by 1.0
    */
    func increment()
    {
        if let value = stack.popLast()
        {
            let result = value+1
            stack.append(result)
        }
    }

    /**
    peek at the top stack item and return it for printing
    * Return: top item on stack
    */
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
    
    /**
    Add the top two stack items
    */
    func plus()
    {
        if let right = stack.popLast()
        {
            if let left = stack.popLast()
            {
                let result = left + right
                stack.append(result)
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
    /**
    subtract the top two stack items from each other
    */
    func minus()
    {
        if let right = stack.popLast()
        {
            if let left = stack.popLast()
            {
                let result = left - right
                stack.append(result)
            }
        }
    }

    /**
    Multiply the top two stack items
    */
    func times()
    {
        if let right = stack.popLast()
        {
            if let left = stack.popLast()
            {
                let result = left * right
                stack.append(result)
            }
        }
    }

    /**
    Divide top two stack items
    */
    func divide()
    {
        if let right = stack.popLast()
        {
            if let left = stack.popLast()
            {
                let result = left / right
                stack.append(result)
            }
        }
    }

    /**
    Take the modulo (divide but return remainder)
    */
    func modulo()
    {
        if let right = stack.popLast()
        {
            if let left = stack.popLast()
            {
                let result = left.truncatingRemainder(dividingBy: right)
                stack.append(result)
            }
        }
    }

    /**
    take the power of the top two stack items, stack[-1]^stack[0]
    */
    func power()
    {
        if let right = stack.popLast()
        {
            if let left = stack.popLast()
            {
                let result = pow(left, right)
                stack.append(result)
            }
        }
    }

    /**
    take the top three stack items and test if the third item is positive,
    returning the second item if it is or the first (top) item if it is not
    
    stack [0] = stack[-2] ? stack[-1] : stack [0]
    
    */
    func if_positive()
    {
        if let alt = stack.popLast()
        {
            if let primary = stack.popLast()
            {
                if let test = stack.popLast()
                {
                    let result = test>0.0 ? primary : alt
                    stack.append(result)
                }
            }
        }
    }
}
