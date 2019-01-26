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
                var cmd:String = String(item)
                var multiplier = 1  //assume we will run at least once
                if (cmd.contains(":"))
                {
                    let cmd_parts = cmd.split(separator: ":")
                    let raw_action = String(cmd_parts[0])
                    let raw_multiplier = String(cmd_parts[1])
                    if let times = Int(raw_multiplier)
                    {
                        if (0 < times)
                        {
                            multiplier = times
                            cmd = String(raw_action)
                        }
                    }
                }
                for _ in 1...multiplier
                {
                    switch cmd
                    {
                        case "help": ans = help()
                        case "=", "p", "P", "d":
                            ans = ans + " " + self.printers(operation: cmd)
                            ans = ans.trimmingCharacters(in: .whitespacesAndNewlines)
                        case "++", "--", "<<", ">>", "^2", "√", "abs", "ceil", "floor", "π", "c":
                            self.unary(operation: cmd)
                        case "+", "-", "*", "/", "%", "^", "<>", "<->", "max", "min":
                            self.binary(operation: cmd)
                        case "?>", "avg":
                            self.ternary(operation: cmd)
                        default:
                            print ("unknown command: \(cmd).")
                    }
                }
                print (stack)
                continue
            }
        }
        return ans;
    }
    
    // MARK: - Operation Types
    
    func printers(operation:String) -> String
    {
        var ans = ""
        switch operation
        {
            case "p", "=": ans = printTop()
            case "P": ans = printTopFormated()
            case "d": ans = dumpAll()
            default:
                ans = ""
                print(stack)
        }
        return ans
    }
    
    /**
    Processes all the operations that are unary in nature ; operations on the
    top most item on the stack
    
    * Parameter operation: name/symble of the operation to perform
    * Returns:
    in most cases, an empty string as there is nothing to print out
    */
    func unary(operation:String)
    {
        switch operation
        {
            case ">>": rotateRight()
            case "<<": rotateLeft()
            case "--": decrement()
            case "++": increment()
            case "^2": square()
            case "√": squareRoot()
            case "π": pie()
            case "c": speedOfLight()
            case "abs": absTop()
            case "floor": floorTop()
            case "ceil": ceilTop()
            default: print(stack)
        }
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
            case "<>", "<->" : swap()
            case "max": max2()
            case "min": min2()
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
    
    // MARK: Printers

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
    peek at the top stack item and return it, formated, for printing. Formated
    by removing unneeded zeros and adding commas for each number group.
    * Return: top item on stack
    */
    func printTopFormated() -> String
    {
        var ans = ""
        if let last = stack.last
        {
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            numberFormatter.groupingSize = 3
            ans = numberFormatter.string(from: NSNumber(value: last))!
            //ans = String(format: "%'0.f", last)
        }
        print("printing ans of \(ans)")
        return ans
    }
    
    /**
    Dump the entire stack out for viewing inside of square brackets.
    * Return: Swift description of an array of Floats
    */
    func dumpAll() -> String
    {
        return stack.description
    }

    // MARK: Binarry operators

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
    find the larger of the top two stack items
    */
    func max2()
    {
        if let right = stack.popLast()
        {
            if let left = stack.popLast()
            {
                let result = max(left, right)
                stack.append(result)
            }
        }
    }
    /**
    find the smaller of the top two stack items
    */
    func min2()
    {
        if let right = stack.popLast()
        {
            if let left = stack.popLast()
            {
                let result = min(left, right)
                stack.append(result)
            }
        }
    }
    
    /**
    swap the top two stack items
    */
    func swap()
    {
        if let right = stack.popLast()
        {
            if let left = stack.popLast()
            {
                stack.append(right)
                stack.append(left)
            }
        }
    }

    // MARK: Unary operators

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
    take the square root of the top stack item
    */
    func squareRoot()
    {
        if let top = stack.popLast()
        {
            let result = sqrt(top)
            stack.append(result)
        }
    }
    
    /**
    square the top stack item
    */
    func square()
    {
        if let top = stack.popLast()
        {
            let result = pow(top, 2)
            stack.append(result)
        }
    }
    
    /**
    Put PI (π) on the stack
    */
    func pie()
    {
        stack.append(Float64.pi)
    }
    
    /**
    Put the speed of light in meters/second on the stack
    */
    func speedOfLight(){stack.append(299792458.0)}
    
    /**
    Find the absolute value of the top stack item
    */
    func absTop()
    {
        if let top = stack.popLast()
        {
            let result = abs(top)
            stack.append(result)
        }
    }

    /**
    Floor the top stack item
    */
    func floorTop()
    {
        if let top = stack.popLast()
        {
            let result = floor(top)
            stack.append(result)
        }
    }

    /**
    Ceil the top stack item
    */
    func ceilTop()
    {
        if let top = stack.popLast()
        {
            let result = ceil(top)
            stack.append(result)
        }
    }
    
    /**
    Rotate the entire stack by taking the last stack item and put it in the front
    Thus, [1, 2, 3] becomes [2, 3, 1]
    */
    func rotateLeft()
    {
        let first = stack.removeFirst()
        stack.append(first)
    }

    /**
    Rotate the entire stack by taking the top stack item and putting at the end.
    Thus, [1, 2, 3] becomes [3, 1, 2]
    */
    func rotateRight()
    {
        if let last = stack.popLast()
        {
            stack.insert(last, at: 0)
        }
    }

    /**
    Take the average of the entire stack and return that value as the sole value
    */
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
