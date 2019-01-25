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
    @IBOutlet weak var kotlinCode: NSScrollView!
    
    var kotlinCodeString: String!
    
    @IBOutlet var swiftCode1: NSTextView!
    @IBOutlet var kotlinCode1: NSTextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
    }

    override var representedObject: Any? {
        didSet {
      
        }
    }

    //Copyied from SwiftKotlin. From here...
    
    @IBAction func openSwiftFile(_ sender: AnyObject) {
        let oPanel: NSOpenPanel = NSOpenPanel()
        oPanel.canChooseDirectories = false
        oPanel.canChooseFiles = true
        oPanel.allowsMultipleSelection = false
        oPanel.allowedFileTypes = ["swift"]
        oPanel.prompt = "Open"
        
        oPanel.beginSheetModal(for: self.view.window!, completionHandler: { (button: NSApplication.ModalResponse) -> Void in
            if button == NSApplication.ModalResponse.OK {
                let filePath = oPanel.urls.first!.path
                let fileHandle = FileHandle(forReadingAtPath: filePath)
                if let data = fileHandle?.readDataToEndOfFile() {
                    self.swiftCode1.textStorage?.beginEditing()
                    self.swiftCode1.textColor = NSColor.black
                    self.swiftCode1.string = String(data: data, encoding: .utf8) ?? ""
                    self.swiftCode1.textStorage?.endEditing()
                    
                    
                }
            }
        })
    }
    
    //To here...  Thanks for Giants.
    
    @IBAction func format(_ sender: NSButton) {
        let swiftCode2: NSTextView = swiftCode.documentView! as! NSTextView
        let swiftCodeString:String = swiftCode2.string

        //Simple line replacements are here.
        kotlinCodeString = swiftCodeString.replacingOccurrences(of: "let", with: "val")
        kotlinCodeString = kotlinCodeString.replacingOccurrences(of: "print", with: "println")
        kotlinCodeString = kotlinCodeString.replacingOccurrences(of: "func", with: "fun")
        kotlinCodeString = kotlinCodeString.replacingOccurrences(of: "->", with: ":")
        kotlinCodeString = kotlinCodeString.replacingOccurrences(of: "\\(", with: "${")
        kotlinCodeString = kotlinCodeString.replacingOccurrences(of: "for i in 0..<count", with: "for (i in 0..count - 1)")
        kotlinCodeString = kotlinCodeString.replacingOccurrences(of: "[String]()", with: "arrayOf<String>()")
        kotlinCodeString = kotlinCodeString.replacingOccurrences(of: "[String: Float]()", with: "mapOf<String, Float>()")

        
        
        //Multiple lines replacements are here.
        
        
        
        
        
        kotlinCode1.string = kotlinCodeString
    }
    

}

