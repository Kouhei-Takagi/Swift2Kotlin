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
        let swiftCodeString:String = swiftCode1.string

        //Simple line replacements are here.
        kotlinCodeString = swiftCodeString.replacingOccurrences(of: "let", with: "val")
        kotlinCodeString = kotlinCodeString.replacingOccurrences(of: "print", with: "println")
        kotlinCodeString = kotlinCodeString.replacingOccurrences(of: "func", with: "fun")
        kotlinCodeString = kotlinCodeString.replacingOccurrences(of: "->", with: ":")
        kotlinCodeString = kotlinCodeString.replacingOccurrences(of: "\\(", with: "${")
        kotlinCodeString = kotlinCodeString.replacingOccurrences(of: "for i in 0..<count", with: "for (i in 0..count - 1)")
        kotlinCodeString = kotlinCodeString.replacingOccurrences(of: "[String]()", with: "arrayOf<String>()")
        kotlinCodeString = kotlinCodeString.replacingOccurrences(of: "[String: Float]()", with: "mapOf<String, Float>()")
        kotlinCodeString = kotlinCodeString.replacingOccurrences(of: "...", with: "..")
        kotlinCodeString = kotlinCodeString.replacingOccurrences(of: "..<", with: "until")
        
        //Multiple lines replacements are here.
        
        
        
        
        
        kotlinCode1.string = kotlinCodeString
    }
    
    @IBAction func saveTxtFile(_ sender: Any) {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let fileObject = kotlinCode1.string
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = formatter.string(from: Date())
        let fileName = "\(date)Kotlin"
        let filePath = documentsPath + "/" + fileName
        
        do {
            try fileObject.write(toFile: filePath, atomically: true,
                                 encoding: String.Encoding.utf8)
            
            let alert = NSAlert()
            alert.messageText = filePath
            alert.runModal()
            
        } catch {
            let alert = NSAlert()
            alert.messageText = "Error"
            alert.runModal()
        }
        
    }
    
}

