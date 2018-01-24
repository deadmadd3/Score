//
//  MainTableViewController.swift
//  Score!
//
//  Created by Madeline Eckhart on 1/2/18.
//  Copyright © 2018 MaddGaming. All rights reserved.
//

import UIKit

class MainTableViewController: UITableViewController {

    var playerList: [Player] = []
    
    @IBAction func btnUpdate(_ sender: Any) {

        let alertController = UIAlertController(title: "Add Player", message: nil, preferredStyle: .alert)
        let alertText = UIAlertAction(title: "Done", style: .default) { (alertAction) in
            let nameTextField = alertController.textFields![0] as UITextField
            self.addPlayer(new_name: nameTextField.text!)
        }
        
        alertController.addTextField{ (nameTextField) in
            nameTextField.placeholder = "Enter Name"
        }
        alertController.addAction(alertText)
        present(alertController, animated: true, completion: nil)
    }
    
    func addPlayer(new_name: String) {
        let newRowIndex = playerList.count
        let person = Player()
        
        person.name = new_name
        person.score = 0
        playerList.append(person)
        
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexpaths = [indexPath]
        tableView.insertRows(at: indexpaths, with: .automatic)
    }
    
    @IBAction func btnAdd(_ sender: AnyObject) {
        let buttonPosition = sender.convert(CGPoint.zero, to: self.tableView)
        let indexPathzz = self.tableView.indexPathForRow(at: buttonPosition)
        
        let alertController = UIAlertController(title: "Enter Number", message: nil, preferredStyle: .alert)
        let alertText = UIAlertAction(title: "Done", style: .default) { (alertAction) in
            let scoreTextField = alertController.textFields![0] as UITextField
            self.editScore(scoreTextField.text!, indexPathzz![1])
        }
        
        alertController.addTextField{ (nameTextField) in
            nameTextField.placeholder = "Number"
        }
        alertController.addAction(alertText)
        present(alertController, animated: true, completion: nil)

    }
    
    @IBAction func btnSubtract(_ sender: AnyObject) {
        let buttonPosition = sender.convert(CGPoint.zero, to: self.tableView)
        let indexPathzz = self.tableView.indexPathForRow(at: buttonPosition)
        
        let alertController = UIAlertController(title: "Enter Number", message: nil, preferredStyle: .alert)
        let alertText = UIAlertAction(title: "Done", style: .default) { (alertAction) in
            let scoreTextField = alertController.textFields![0] as UITextField
            self.editScore("-" + scoreTextField.text!, indexPathzz![1])
        }
        
        alertController.addTextField{ (nameTextField) in
            nameTextField.placeholder = "Number"
        }
        alertController.addAction(alertText)
        present(alertController, animated: true, completion: nil)
    }
    
    func editScore(_ num: String, _ index: Int) {
        let addThis = Int(num)!
        playerList[index].score = playerList[index].score + addThis
        tableView.reloadData()

    }
    
    @IBAction func btnReorder(_ sender: Any) {
        // Insertion Sort
        var key, j : Int
            for i in 1 ..< playerList.count {
                key = self.playerList[i].score;
                j = i-1;

                while j >= 0 && self.playerList[j].score > key {
                    self.playerList[j+1].score = self.playerList[j].score;
                    j = j-1;
                }
                self.playerList[j+1].score = key;
            }
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "player", for: indexPath)
        let person = playerList[indexPath.row]
        configureText(for: cell, with: person)
        configureScore(for: cell, with: person)
        return cell
    }
    
    func configureText(for cell: UITableViewCell, with item: Player){
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = item.name
    }
    
    func configureScore(for cell: UITableViewCell, with item: Player){
        let score = cell.viewWithTag(1001) as! UILabel
        score.text = "\(item.score)"
    }
    
    // Delete Player
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            playerList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return playerList.count
    }

    


}
