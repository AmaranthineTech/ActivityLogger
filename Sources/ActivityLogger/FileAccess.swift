//
//  File.swift
//  
//
//  Created by Arun Patwardhan on 03/03/20.
//

import Foundation

/**
 FileAccess class holds the logic for read and write operations to the log file
 
 **Variables**
 
 `internalValue`
 
 This is the internally stored value.
 
 **Computed Property**
 
 `wrappedValue`
 
 This is the computed property that will perform the logging action.
 
 - Author: Arun Patwardhan
 - Version: 1.0
 - Date: 5th December 2019
 
 **Contact Details**
 
 [arun@amaranthine.co.in](mailto:arun@amaranthine.co.in)
 
 [www.amaranthine.in](https://www.amaranthine.in)
 */
final class FileAccess
{
    //----------------------------------------------------------------------------------------------------
    //MARK: - Variables
    private static var fileHandle   : FileAccess?
    static func getFileHandle(forFileNamed newFileName : String) -> FileAccess
    {
        if fileHandle == nil
        {
            fileHandle = FileAccess(fileName: newFileName)
        }
        return fileHandle!
    }
    
    private init(fileName : String)
    {
        self.logFileName            = fileName
        self.documentsDirectoryURL  = try! FileManager.default.url(for: .documentDirectory,
                                                                   in: .userDomainMask,
                                                                   appropriateFor: nil,
                                                                   create: true)
        
        self.logFileURL             = self.documentsDirectoryURL?.appendingPathComponent(self.logFileName).appendingPathExtension(self.logFileExtension)
        if FileManager.default.fileExists(atPath: self.logFileURL!.path)
        {
            print(self.logFileURL?.absoluteString)
        }
        else
        {
            print(#line, "ERR: FIle not found")
        }
    }
    //----------------------------------------------------------------------------------------------------
    //MARK: - Variables
    var logFileName             : String    = ""
    let documentsDirectoryURL   : URL?
    var logFileURL              : URL?
    let logFileExtension        : String    = "log"
    var previousLogs            : String    = ""
    
    //----------------------------------------------------------------------------------------------------
    //MARK: - Functions
    /**
     This is method writes to the log file
     - parameter message: This is the message to be written to the log file.
     - requires: iOS 13 or later
     - Since: iOS 13
     - author: Arun Patwardhan
     - copyright: Copyright (c) Amaranthine 2020
     - version: 1.0
     - date: 3rd March 2020
     */
    @available(iOS, introduced: 13.0, message: "This is the init method for the logger struct")
    func log(TheMessage message :String)
    {
        let timeStamp       : Date          = Date(timeIntervalSinceNow: 0)
        let dateFormatter   : DateFormatter = DateFormatter()
        dateFormatter.dateStyle             = DateFormatter.Style.full
        
        self.previousLogs                   = self.readLogs()
        
        let finalMessage    : String        = self.previousLogs + "\n" + dateFormatter.string(from: timeStamp) + " " + message
        do
        {
            try finalMessage.write(to: self.logFileURL!,
                                   atomically: true,
                                   encoding: String.Encoding.utf8)
        }
        catch let error
        {
            print(#line, error)
        }
        
        if FileManager.default.fileExists(atPath: self.logFileURL!.path)
        {
            print(self.logFileURL?.absoluteString)
        }
        else
        {
            print(#line, "ERR: FIle not found")
        }
    }
    
    func readLogs() -> String
    {
        var readMessage : String = ""
        do
        {
            readMessage = try String(contentsOf: self.logFileURL!)
        }
        catch let error
        {
            print(#line, error)
        }
        return readMessage
    }
}
