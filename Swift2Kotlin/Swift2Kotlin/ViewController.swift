//
//  ViewController.swift
//  Swift2Kotlin
//
//  Created by 高木耕平 on 2019/01/24.
//  Copyright © 2019 高木耕平. All rights reserved.
//

import Cocoa
import Foundation

class ViewController: NSViewController {

    
    @IBOutlet weak var swiftCode: NSScrollView!
    @IBOutlet weak var kotlinCode: NSTextField!
    
    var kotlinCodeString: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
    }

    override var representedObject: Any? {
        didSet {
      
        }
    }

    
    @IBAction func format(_ sender: NSButton) {
        let swiftCode2: NSTextView = swiftCode.documentView! as! NSTextView
        let swiftCodeString:String = swiftCode2.string

        kotlinCodeString = swiftCodeString.replacingOccurrences(of: "let", with: "val")
        kotlinCodeString = kotlinCodeString.replacingOccurrences(of: "print", with: "println")
        kotlinCodeString = kotlinCodeString.replacingOccurrences(of: "func", with: "fun")
        kotlinCodeString = kotlinCodeString.replacingOccurrences(of: "->", with: ":")
        
        
        
        
        
        kotlinCode.stringValue = kotlinCodeString
    }
    

}

