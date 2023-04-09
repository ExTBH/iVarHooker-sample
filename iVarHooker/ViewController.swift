//
//  ViewController.swift
//  iVarHooker
//
//  Created by Natheer on 26/03/2023.
//

import UIKit
import FLEX
import TypesValidator

class ViewController: UIViewController {
    
    public func readPrivateIvar<T>(_ iVar: Ivar, type: T.Type, in idk: AnyObject) -> UnsafePointer<T>? {
        let idkPtr = unsafeBitCast(idk, to: uintptr_t.self)
        let iVarOffset = UInt(ivar_getOffset(iVar))
        let ptr = UnsafeRawPointer(bitPattern: idkPtr + iVarOffset)?.assumingMemoryBound(to: type)
        return ptr
        
        
    }
    public func ptrToPrivateIvar(_ iVar: Ivar, in idk: AnyObject) -> UnsafeRawPointer? {
        let idkPtr = unsafeBitCast(idk, to: uintptr_t.self)
        let iVarOffset = UInt(ivar_getOffset(iVar))
        let ptr = UnsafeRawPointer(bitPattern: idkPtr + iVarOffset)
        return ptr
        
        
    }
    // ChatGPT
    public func createObjectPtr(from pointer: UnsafeRawPointer, size: Int) -> UnsafeMutableRawPointer? {
        let objectPointer = UnsafeMutableRawPointer.allocate(byteCount: size, alignment: MemoryLayout<Any>.alignment)
        memcpy(objectPointer, pointer, size)
        return objectPointer
    }

    
    private let testBool = true
    private let testTable = UITableView(frame: .null, style: .insetGrouped)
    private let testNSString: NSString = "An NSString"
    private let testString: String = "Not an NSString"
    private let arrNSString: [NSString] = ["NS1", "NS2"]
    private let arrString: [String] = ["S1", "S2"]
    private let human1 = Human(name: "Deez", age: 18)
    private let humanArr = [Human(name: "ExT", age: 18), Human(name: "Leptos", age: -1)]
    private let testInteger = 696969
    private let testDictStruct = ["name": "ext", "age": 18] as [String : Any]
    private let testNSDict: NSDictionary = ["name": "ext", "age": 18]

    override func viewDidLoad() {
        super.viewDidLoad()
        let selfPtr = unsafeBitCast(self, to: uintptr_t.self)
        // Do any additional setup after loading the view.
        let iVars = class_copyIvarList(self.classForCoder, nil)
        // hook bool
        let boolPtr = readPrivateIvar(iVars![0], type: Bool.self, in: self)
        print(boolPtr?.pointee as Any)
        print("----------")
        // table
        let tablePtr = readPrivateIvar(iVars![1], type: UITableView.self, in: self)
        print(tablePtr?.pointee as Any)
        print("----------")
        // NSString
        let nsStringPtr = readPrivateIvar(iVars![2], type: NSString.self, in: self)
        print(nsStringPtr?.pointee as Any)
        print("----------")
        // String
        let stringPtr = readPrivateIvar(iVars![3], type: String.self, in: self)
        print(stringPtr?.pointee as Any)
        print("----------")
        // Arr NSString
        let arrNSStringPtr = readPrivateIvar(iVars![4], type: Array<AnyObject>.self, in: self) // `Any` causes bad Access
        print(arrNSStringPtr?.pointee as Any)
        print("----------")
        // Arr NSString
        let arrStringPtr = readPrivateIvar(iVars![5], type: Array<String>.self, in: self) // Type must be specified
        print(arrStringPtr?.pointee as Any)
        print("----------")
        // Struct Human
        /// the replica doesn't have to be 1 to 1, you can only have 1 property in it, or add extra properties thats not there
        let humanPtr = readPrivateIvar(iVars![6], type: HumanReplica.self, in: self)
        let mutableHumanPtr = UnsafeMutablePointer(mutating: humanPtr)
        mutableHumanPtr?.pointee.name = "DaBaby"
        print(humanPtr?.pointee as Any)
        print(human1)
        print("----------")
        // Array of Structs
        /// The Array must be 1 to 1 Replica, wrong size wlll crash with BAD ACCESS
        let humanArrPtr = readPrivateIvar(iVars![7], type: Array<HumanReplica1T1>.self, in: self)
        print(humanArrPtr?.pointee as Any)
        print("----------")
        // runtime reflection
        let intOffset = UInt(ivar_getOffset(iVars![0]))
        let nextOffset = UInt(ivar_getOffset(iVars![1]))
        print(intOffset, nextOffset)
        let size = Int(nextOffset - intOffset)
        print(size)
        let address = UnsafeRawPointer(bitPattern: selfPtr + intOffset)!
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: size)
        buffer.initialize(from: address.assumingMemoryBound(to: UInt8.self), count: size)
        
        print("is Bool: \(isBoolean(buffer, size))")
        buffer.deallocate()
        sizes()
        
        


    }
    func sizes() {
        print("----- Sizes -----")
        print("Int8 & UInt8: \(MemoryLayout<Int8>.size)")
        print("Int16 & UInt16: \(MemoryLayout<Int16>.size)")
        print("Int32 * UInt32: \(MemoryLayout<Int32>.size)")
        print("Int64 & UInt64: \(MemoryLayout<Int64>.size)")
        print("Int & UInt: \(MemoryLayout<Int>.size)")
        print("Float: \(MemoryLayout<Float>.size)")
        print("Double: \(MemoryLayout<Double>.size)")
        print("Bool: \(MemoryLayout<Bool>.size)")
        print("Character: \(MemoryLayout<Character>.size)")
        print("String: \(MemoryLayout<String>.size)")
        print("Array<Any>: \(MemoryLayout<Array<Any>>.size)")
        print("NSObject: \(MemoryLayout<NSObject>.size)")
        print("NSString: \(MemoryLayout<NSString>.size)")
        print("AnyObject: \(MemoryLayout<AnyObject>.size)")
        print("Human: \(MemoryLayout<Human>.size)")
        print("----- Sizes -----")

    }
}

public struct HumanReplica {
    var name: String
}

public struct HumanReplica1T1 {
    let name: String
    let age: Int
}

private struct Human {
    let name: String
    let age: Int
}
