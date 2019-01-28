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
        kotlinCodeString = swiftCodeString.replacingOccurrences(of: "let ", with: "val ")
        kotlinCodeString = kotlinCodeString.replacingOccurrences(of: "print", with: "println")
        kotlinCodeString = kotlinCodeString.replacingOccurrences(of: "func ", with: "fun ")
        kotlinCodeString = kotlinCodeString.replacingOccurrences(of: "->", with: ":")
        kotlinCodeString = kotlinCodeString.replacingOccurrences(of: "\\(", with: "${")
        kotlinCodeString = kotlinCodeString.replacingOccurrences(of: "for i in 0..<count", with: "for (i in 0..count - 1)")
        kotlinCodeString = kotlinCodeString.replacingOccurrences(of: "[String]()", with: "arrayOf<String>()")
        kotlinCodeString = kotlinCodeString.replacingOccurrences(of: "[String: Float]()", with: "mapOf<String, Float>()")
        kotlinCodeString = kotlinCodeString.replacingOccurrences(of: "...", with: "..")
        kotlinCodeString = kotlinCodeString.replacingOccurrences(of: "..<", with: "until")
        kotlinCodeString = kotlinCodeString.replacingOccurrences(of: "switch ", with: "when ")
        
        //Multiple lines replacements are here.
        var sentenceFun = kotlinCodeString!
        var arr:[String]
        var arr2:[String]
        var token : String
        var token2 : String
        
        if sentenceFun.contains("for ") {
            arr = sentenceFun.components(separatedBy: "for")
            arr2 = arr[1].components(separatedBy: "{")
            token = String(arr[1][(arr[1].index(of: " ") ?? arr[1].startIndex)..<(arr[1].index(of: "{") ?? arr[1].index(before: arr[1].endIndex))]);
            token = "for " + "(" + token + ")"
            arr2.remove(at: 0)
            token = token + " {" + arr2.joined()
            arr[1] = token
            sentenceFun = arr.joined()
        }
        kotlinCodeString = sentenceFun
        
        if sentenceFun.contains("when ") {
            arr = sentenceFun.components(separatedBy: "when")
            arr2 = arr[1].components(separatedBy: "}")
            token = String(arr[1][(arr[1].index(of: " ") ?? arr[1].startIndex)..<(arr[1].index(of: "{") ?? arr[1].index(before: arr[1].endIndex))]);
            token = "when " + "(" + token + ")"
            token2 = String(arr2[0][(arr2[0].index(of: "{") ?? arr2[0].startIndex)...(arr2[0].index(of: "}") ?? arr2[0].index(before: arr2[0].endIndex))]);
            token2 = token2.replacingOccurrences(of: "case", with: "in")
            token2 = token2.replacingOccurrences(of: "default", with: "else")
            arr2.remove(at: 0)
            token2 = token2  + " }" + arr2.joined()
            arr[1] = token + token2
            sentenceFun = arr.joined()
        }
        kotlinCodeString = sentenceFun
        
        
        kotlinCode1.string = kotlinCodeString
    }
    
    @IBAction func saveTxtFile(_ sender: Any) {
        //Copied from http://www.royalcrab.net/wpx/?p=6171
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

