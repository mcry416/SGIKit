//
//  FileHelper.swift
//  EHICompent
//
//  Created by MengQingyu iMac on 2022/8/2.
//

import UIKit

class FileHelper: NSObject {
    
    private static let DOCU: String = "Document"

    private lazy var lock: NSLock = {
        return NSLock()
    }()
    
}

// MARK: - Existence
extension FileHelper{
    
    public static func isExistence(file: String, isDirectory: Bool = false) -> Bool{
        let fileManager = FileManager.default
        let filePath: String = NSHomeDirectory() + "\(DOCU)/\(file)"
        if isDirectory {
            var condition: ObjCBool = ObjCBool(true)
            return fileManager.fileExists(atPath: filePath, isDirectory: &condition)
        }
        return fileManager.fileExists(atPath: filePath)
    }
    
}

// MARK: - Read
extension FileHelper{
    
    enum FileHelperSearchDegree {
        case depth
        case light
    }
    
    enum FileHelperReadType {
        case text
        case picture
        case dictionary
    }
    
    public static func readAsStrings(searchMode: FileHelperSearchDegree) -> Array<String>?{
        let manager = FileManager.default
        let urlForDocument = manager.urls(for: .documentDirectory, in: .userDomainMask)
        let url = urlForDocument[0] as URL
        if searchMode == .light {
            let contentsPath = try? manager.contentsOfDirectory(atPath: url.path)
            return contentsPath
        }
        if searchMode == .depth {
            let enumeratorAtPath = manager.enumerator(atPath: url.path)
            return enumeratorAtPath?.allObjects as? Array<String>
        }
        return nil
    }
    
    public static func readAsURLs(searchMode: FileHelperSearchDegree) -> Array<URL>?{
        let manager = FileManager.default
        let urlForDocument = manager.urls(for: .documentDirectory, in: .userDomainMask)
        let url = urlForDocument[0] as URL
        if searchMode == .light {
            let contentsPath = try? manager.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
            return contentsPath
        }
        if searchMode == .depth {
            let contentsPath = try? manager.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
            return contentsPath
        }
        return nil
    }
    
    public static func readAsStrings(atPath path: String, searchMode: FileHelperSearchDegree) -> Array<String>?{
        let manager = FileManager.default
        let urlForDocument = manager.urls(for: .documentDirectory, in: .userDomainMask)
        let url = (urlForDocument[0] as URL).appendingPathExtension(path)
        if searchMode == .light {
            let contentsPath = try? manager.contentsOfDirectory(atPath: url.path)
            return contentsPath
        }
        if searchMode == .depth {
            let enumeratorAtPath = manager.enumerator(atPath: url.path)
            return enumeratorAtPath?.allObjects as? Array<String>
        }
        return nil
    }
    
    public static func readAsURLs(atPath path: String, searchMode: FileHelperSearchDegree) -> Array<URL>?{
        let manager = FileManager.default
        let urlForDocument = manager.urls(for: .documentDirectory, in: .userDomainMask)
        let url = (urlForDocument[0] as URL).appendingPathExtension(path)
        if searchMode == .light {
            let contentsPath = try? manager.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
            return contentsPath
        }
        if searchMode == .depth {
            let contentsPath = try? manager.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
            return contentsPath
        }
        return nil
    }
    
    public static func readFile(fromPath: String, fileType type: FileHelperReadType) -> Any?{
        let fileManager = FileManager.default
        let urlsForDocument = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        let docuPath = urlsForDocument[0]
        let file = docuPath.appendingPathExtension(fromPath)
        
        let readHandler = try! FileHandle(forReadingFrom: file)
        let data = readHandler.readDataToEndOfFile()
        
        switch type {
        case .text:
            let content = String(data: data, encoding: .utf8)
            return content
        case .picture:
            let pngImage = UIImage(data: data)
            return pngImage
        case .dictionary:
            let homePath = NSHomeDirectory() + DOCU + "/" + fromPath
            let dictionary = try! NSDictionary(contentsOf: URL(string: homePath)!, error: ())
            return dictionary
        }
    }
    
}

// MARK: - Write
extension FileHelper{
    
    enum FileHelperWriteType {
        case text
        case picturePNG
        case pictureJPG
        case dictionary
    }

    public static func write(intoFolderPath path: String){
        let directory: String = NSHomeDirectory() + "\(DOCU)/\(path)"
        let fileManager = FileManager.default
        try! fileManager.createDirectory(atPath: directory, withIntermediateDirectories: true, attributes: nil)
    }
    
    public static func write(intoFile file: Any, atFulllyPath path: String, fileType type: FileHelperWriteType){
        switch type {
        case .text:
            let filePath: String = NSHomeDirectory() + "\(DOCU)/\(path).txt"
            let content: String = file as! String
            try! content.write(toFile: filePath, atomically: true, encoding: .utf8)
        case .picturePNG:
            let filePath = NSHomeDirectory() + "\(DOCU)/\(path).png"
            let image: UIImage = file as! UIImage
            let data: Data = image.pngData()!
            try? data.write(to: URL(fileURLWithPath: filePath))
        case .pictureJPG:
            let filePath = NSHomeDirectory() + "\(DOCU)/\(path).jpg"
            let image: UIImage = file as! UIImage
            let data: Data = image.jpegData(compressionQuality: 1)!
            try? data.write(to: URL(fileURLWithPath: filePath))
        case .dictionary:
            let filePath: String = NSHomeDirectory() + "\(DOCU)/\(path).plist"
            let dictionary: NSDictionary = file as! NSDictionary
            dictionary.write(to: URL(string: filePath)!, atomically: true)
        }
    }
    
}

// MARK: - Copy
extension FileHelper{
    
    public static func copyFile(from oldPath: String, to newPath: String){
        let fileManager = FileManager.default
        let homeDirectory = NSHomeDirectory()
        let sourceUrl = homeDirectory + "\(DOCU)/\(oldPath)"
        let newUrl = homeDirectory + "\(DOCU)/\(newPath)"
        try! fileManager.copyItem(atPath: sourceUrl, toPath: newUrl)
    }
}

// MARK: - Move
extension FileHelper{
    
    public static func moveFile(from oldPath: String, to newPath: String){
        let fileManager = FileManager.default
        let homeDirectory = NSHomeDirectory()
        let sourceUrl = homeDirectory + "\(DOCU)/\(oldPath)"
        let newUrl = homeDirectory + "\(DOCU)/\(newPath)"
        try! fileManager.moveItem(atPath: sourceUrl, toPath: newUrl)
    }
    
}

// MARK: - Delete
extension FileHelper{
    
    public static func delete(specifyFilePath path: String){
        let fileManager = FileManager.default
        let deletedPath = NSHomeDirectory() + "\(DOCU)/\(path)"
        try! fileManager.removeItem(atPath: deletedPath)
    }
    
    public static func deleteFolderContents(path: String){
        let fileManager = FileManager.default
        let deletedPath = NSHomeDirectory() + DOCU + "/\(path)"
        let files = fileManager.subpaths(atPath: deletedPath)
        files?.forEach({ concreteFilePath in
            try! fileManager.removeItem(atPath: concreteFilePath)
        })
    }
    
}

// MARK: - Convenience Method
extension FileManager{
    
    public static func documentPath(subPath: String?) ->String{
        if (subPath?.count ?? 0) > 0 {
            return NSHomeDirectory() + "Document" + "/" + subPath!
        }
        return NSHomeDirectory() + "Document" + "/"
    }
    
    public static func getFileAttributes(fullPath: String) -> [FileAttributeKey : Any]?{
        let fileManager = FileManager.default
        let urlForDocument = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        let documentPath = urlForDocument[0]
        let file = documentPath.appendingPathExtension(fullPath)
        if let attributes = try? fileManager.attributesOfItem(atPath: file.path) {
            return attributes
        }
        return nil
    }
    
}
