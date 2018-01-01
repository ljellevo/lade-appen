//
//  ChangeUserInfo.swift
//  ladeBilen
//
//  Created by Ludvig Ellevold on 01.01.2018.
//  Copyright © 2018 Ludvig Ellevold. All rights reserved.
//

import UIKit

class ChangeUserInfo: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate  {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var rowIndex: Int?
    var placeholder: String?


    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "EntryCell", bundle: nil), forCellReuseIdentifier: "EntryCell")
        if rowIndex == 0 {
            placeholder = GlobalResources.user?.firstname
        } else if rowIndex == 1 {
            placeholder = GlobalResources.user?.lastname
        } else {
            placeholder = GlobalResources.user?.email
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    /*
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: EntryCell = tableView.dequeueReusableCell(withIdentifier: "EntryCell", for: indexPath) as! EntryCell
        cell.textField.text = placeholder
        return cell
        
    }
 */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "EditableCells")
        let textField = UITextField(frame: CGRect(x: 8, y: 8, width: (UIScreen.main.bounds.width - 16), height: 30))
        textField.backgroundColor = UIColor.white
        textField.text = placeholder
        cell.contentView.addSubview(textField)
        textField.delegate = self // set delegate
        textField.tag = indexPath.row
        return cell
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print(textField.tag)
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        print(textField.tag)
        placeholder = textField.text
        return false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    
    
}
