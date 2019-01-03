//
//  ImageManager.swift
//  ladeBilen
//
//  Created by Ludvig Ellevold on 03/01/2019.
//  Copyright © 2019 Ludvig Ellevold. All rights reserved.
//

import Foundation
import FirebaseStorage

class ImageManager {
    let storage = Storage.storage()
    
    
    /**
     Fetches station image from Firebase Storage. Max image size is 1MB but can be changed by modifying (1 * 1024 * 1024)
     
     - Parameter stationId: The station id as a string with added notation "NOR_0...."
     - Parameter code: Callback
     
     - Returns: A callback when image has been fetched.
     This callback block consists of <Optional image, status code>
     If status code is 0 then image is safe to unwrap.
     */
    func getImageForStation(stationId: String, done: @escaping (_ image: UIImage?, _ code: Int)-> Void){
        let stationImageRef = storage.reference().child("photos/stations/" + stationId + "/station.jpg")
        
        stationImageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if error != nil {
                done(nil, 1)
            } else {
                let image = UIImage(data: data!)
                done(image, 0)
            }
        }
 
        /*
        let documentFolder = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let destination = URL(fileURLWithPath: documentFolder).appendingPathComponent("photos/stations/" + stationId, isDirectory: true)
        let fileManager = FileManager.default
        do {
            try fileManager.createDirectory(at: destination, withIntermediateDirectories: true, attributes: nil)
        }
        catch {
            fatalError("Unable to create cache URL: \(error)")
        }
        
        let localURL = URL(string: destination.absoluteString + "station.jpg")!
        stationImageRef.write(toFile: localURL) { url, error in
            if error != nil {
                print(error)
                done(nil, 1)
            } else {
                done(url, 0)
            }
        }
        */
    }
}
