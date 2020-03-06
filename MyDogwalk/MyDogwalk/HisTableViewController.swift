//
//  HisTableViewController.swift
//  MyDogwalk
//
//  Created by Putte on 2018-12-28.
//  Copyright © 2018 Putte. All rights reserved.
//

import UIKit

class HisTableViewController: UIViewController
{
    @IBOutlet weak var tableView: UITableView!
    
    var list: [listTxt] = []

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        list = createArray()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func createArray() -> [listTxt]
    {
        var tempTxt: [listTxt] = []
        
        let txt1 = listTxt(dog: "Lexi", person: "Putte", action: "Kiss", time: "14:25", date: "2018-12-28")
        let txt2 = listTxt(dog: "Selma", person: "Fredrik", action: "Lek", time: "14:27", date: "2018-12-28")
        let txt3 = listTxt(dog: "Lexi & Selma", person: "Rebecca", action: "Kiss & Bajs", time: "14:30", date: "2018-12-28")
        
        tempTxt.append(txt1)
        tempTxt.append(txt2)
        tempTxt.append(txt3)
        
        return tempTxt
    }
}
extension HisTableViewController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let listPath = list[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell") as! HistoryCell
        
        cell.setCell(list: listPath)
        
        return cell
    }
}

