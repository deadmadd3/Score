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
    
    // Add Player
    @IBAction func btnUpdate(_ sender: Any) {

        let alertController = UIAlertController(title: "Add Player", message: nil, preferredStyle: .alert)
        let alertText = UIAlertAction(title: "Done", style: .default) { (alertAction) in
            let nameTextField = alertController.textFields![0] as UITextField
            self.addPlayer(new_name: nameTextField.text!)
        }
        
        alertController.addTextField{ (nameTextField) in
            nameTextField.autocapitalizationType = .words
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
        if person.name == "" {
            return 
        }else{
            playerList.append(person)
        }
        
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
        
        alertController.addTextField{ (scoreTextField) in
            scoreTextField.keyboardType = .numberPad
            scoreTextField.placeholder = "Number"
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
        
        alertController.addTextField{ (scoreTextField) in
            scoreTextField.keyboardType = .numberPad
            scoreTextField.placeholder = "Number"
            
        }
        alertController.addAction(alertText)
        present(alertController, animated: true, completion: nil)
    }
    
    func editScore(_ num: String, _ index: Int) {
        
        guard let addThis = Int(num) else {
            let addThis = 0
            return
        }
        playerList[index].score = playerList[index].score + addThis
        tableView.reloadData()

    }
    
    @IBAction func btnReorder(_ sender: Any) {
        
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let ascendingText = UIAlertAction(title: "Ascending Order", style: .default) { _ in
            self.playerList.sort{$0.score > $1.score}
            self.tableView.reloadData()
        }
        let descendingText = UIAlertAction(title: "Descending Order", style: .default) { _ in
            self.playerList.sort{$0.score < $1.score}
            self.tableView.reloadData()
        }
        let cancelText = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(cancelText)
        alertController.addAction(ascendingText)
        alertController.addAction(descendingText)
        
        if let popoverController = alertController.popoverPresentationController {
            popoverController.barButtonItem = sender as? UIBarButtonItem
        }
        
        present(alertController, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "player", for: indexPath)
        let person = playerList[indexPath.row]
        tableView.separatorColor = UIColor.init(red: 0.09, green: 0.51, blue: 0.57, alpha: 0)
        configureText(for: cell, with: person)
        configureScore(for: cell, with: person)
        return cell
    }
    
    func configureText(for cell: UITableViewCell, with item: Player) {
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = item.name
    }
    
    func configureScore(for cell: UITableViewCell, with item: Player) {
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
    
    // Table View
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.separatorColor = UIColor.init(red: 0.09, green: 0.51, blue: 0.57, alpha: 0)
        return playerList.count
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // Delay Launch
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        Thread.sleep(forTimeInterval: 5.0)
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
