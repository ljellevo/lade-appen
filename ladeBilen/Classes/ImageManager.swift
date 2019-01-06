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
    func getImageForStation(stationId: String, user: User, done: @escaping (_ image: UIImage?, _ code: Int)-> Void){
        var stationImageRef = storage.reference()
        if user.reduceData {
            stationImageRef = stationImageRef.child("photos/stations/" + stationId + "/station_lowres.jpg")
        } else {
            stationImageRef = stationImageRef.child("photos/stations/" + stationId + "/station.jpg")
        }
        
        
        stationImageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if error != nil {
                done(nil, 1)
            } else {
                let image = UIImage(data: data!)
                done(image, 0)
            }
        }
    }
}
