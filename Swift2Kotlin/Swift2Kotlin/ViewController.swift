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
        var arr:[String] = sentenceFun.components(separatedBy: "for")
        var arr2:[String]
        var token : String
        var token2 : String
        var numberFor : Int = arr.count - 1
        
        while numberFor > 0 {
            arr2 = arr[(numberFor)].components(separatedBy: "{")
            token = String(arr[(numberFor)][(arr[(numberFor)].index(of: " ") ?? arr[(numberFor)].startIndex)..<(arr[(numberFor)].index(of: "{") ?? arr[(numberFor)].index(before: arr[(numberFor)].endIndex))]);
            token.removeFirst(1)
            token.removeLast(1)
            token = "for " + "(" + token + ") "
            arr2.remove(at: 0)
            token = token + "{" + arr2.joined(separator: "{")
            arr[(numberFor)] = token
            sentenceFun = arr.joined()
            numberFor = numberFor - 1
        }
        
        arr = sentenceFun.components(separatedBy: "if")
        numberFor = arr.count - 1
        while numberFor > 0 {
            arr2 = arr[(numberFor)].components(separatedBy: "{")
            token = String(arr[(numberFor)][(arr[(numberFor)].index(of: " ") ?? arr[(numberFor)].startIndex)..<(arr[(numberFor)].index(of: "{") ?? arr[(numberFor)].index(before: arr[(numberFor)].endIndex))]);
            token.removeFirst(1)
            token.removeLast(1)
            token = "if " + "(" + token + ") "
            arr2.remove(at: 0)
            token = token + "{" + arr2.joined(separator: "{")
            arr[(numberFor)] = token
            sentenceFun = arr.joined()
            numberFor = numberFor - 1
        }
        
        arr = sentenceFun.components(separatedBy: "when")
        numberFor = arr.count - 1
        
        while numberFor > 0 {
            token = String(arr[(numberFor)][(arr[(numberFor)].index(of: " ") ?? arr[(numberFor)].startIndex)..<(arr[(numberFor)].index(of: "{") ?? arr[(numberFor)].index(before: arr[(numberFor)].endIndex))]);
            token.removeFirst(1)
            token.removeLast(1)
            token = "when " + "(" + token + ") "
            arr2 = arr[(numberFor)].components(separatedBy: "}")
            token2 = String(arr2[0][(arr2[0].index(of: "{") ?? arr2[0].startIndex)...(arr2[0].index(of: "}") ?? arr2[0].index(before: arr2[0].endIndex))]);
            token2 = token2.replacingOccurrences(of: "case", with: "in")
            token2 = token2.replacingOccurrences(of: "default", with: "else")
            arr2.remove(at: 0)
            arr[(numberFor)] = token + token2 + "}" + arr2.joined(separator: "}")
            sentenceFun = arr.joined()
            numberFor = numberFor - 1
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

