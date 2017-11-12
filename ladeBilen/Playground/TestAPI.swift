//
//  testApiViewController.swift
//  ladeBilen
//
//  Created by Ludvig Ellevold on 26.06.2017.
//  Copyright © 2017 Ludvig Ellevold. All rights reserved.
//

import UIKit

class TestAPI: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func clicked(_ sender: UIButton) {
        php()
    }
    
    func jsonPost(){
        let fullUrl = "http://nobil.no/api/server/search.php?apikey=5aeda7ca3cdef320f824f1b2a93859f0&apiversion=3&action=search&type=stats_TotalsByCountyId&id=11&countycode=NO"
        
        let json: [String: Any] = ["data": [
            "apikey": "5aeda7ca3cdef320f824f1b2a93859f0",
            "apiversion": "3",
            "action": "search",
            "type": "id",
            "id": "NOR_00171"]]
        
        let url = URL(string: "http://nobil.no/api/server/search.php")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let jsonData = try? JSONSerialization.data(withJSONObject: json)

        // insert json data to the request
        request.httpBody = jsonData
    }
    
    
    
    func php(){
        let urlPhp = URL(string:"http://nobil.no/api/server/search.php?apikey=5aeda7ca3cdef320f824f1b2a93859f0&apiversion=3&action=search&type=stats_AllDetailsByCountyId&id=11&countrycode=NOR")!
        
        let requestPhp = URLRequest(url: urlPhp)
        
        let task = URLSession.shared.dataTask(with: requestPhp) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                print(responseJSON)
            }
        }
        task.resume()
    }
}
