//
//  TestThread.swift
//  ladeBilen
//
//  Created by Ludvig Ellevold on 28.11.2017.
//  Copyright © 2017 Ludvig Ellevold. All rights reserved.
//

import Foundation

class TestThread{
    var run: Bool = true
    
    func backgroundThread(){
        DispatchQueue.global(qos: .background).async {
            while self.run{
                DispatchQueue.main.async {
                    print("Running")
                }
                sleep(1)
            }
            print("Stopped")
        }
    }
}
