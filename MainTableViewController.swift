//
//  MainTableViewController.swift
//  Score!
//
//  Created by Madeline Eckhart on 1/2/18.
//  Copyright © 2018 MaddGaming. All rights reserved.
//

import UIKit

class MainTableViewController: UITableViewController {

    
    //----------------------------------------------- Navigation Bar Functions -----------------------------------------------//
    
    var playerList: [Player] = []

    // Add Player
    @IBAction func btnNewPlayer(_ sender: Any) {
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
    
    //----------------------------------------------- ToolBar Functions -----------------------------------------------//
    
    @IBAction func btnSave(_ sender: Any) {
        let listOfScores: [Player] = []
        
        let app: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let scorecard = app.scorecard as! Scorecard
        
        // Creating the save file alert
        let saveCard = UIAlertController(title: "Save Scorecard", message: "Please enter the file name:", preferredStyle: UIAlertControllerStyle.alert)
        
        saveCard.addTextField(configurationHandler: {(textField: UITextField) in
            textField.placeholder = scorecard.filename
            textField.keyboardType = UIKeyboardType.alphabet })
        
        let btnSave = UIAlertAction(title: "Save", style: UIAlertActionStyle.default, handler: {(saveAction: UIAlertAction) in
            var filename: String? = saveCard.textFields![0].text!
            if (filename?.isEmpty)! {
                filename = saveCard.textFields![0].placeholder
            }
            if (filename == nil) {
                //empty filename
                let emptyController = UIAlertController(title: "No file name", message: "Save cancelled", preferredStyle: UIAlertControllerStyle.alert)
                let btnCancel = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
                
                emptyController.addAction(btnCancel)
                self.present(emptyController, animated: true, completion: nil)
                
                return
            }
            
            if (listOfScores.contains(where: filename!)){
                // overwrite existing survey
                let overwriteController = UIAlertController(title: "Warning", message: "A file already exists with that name.", preferredStyle: UIAlertControllerStyle.alert)
                
                let btnOverwrite = UIAlertAction(title: "Overwrite", style: UIAlertActionStyle.default, handler: {(saveAction: UIAlertAction) in
                    let filename: String = saveCard.textFields![0].text!
                    self.saveCard(filename: filename) })
                let btnCancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
                
                overwriteController.addAction(btnOverwrite)
                overwriteController.addAction(btnCancel)
                
                self.present(overwriteController, animated: true, completion: nil)
            } else {
                self.saveSurvey(filename: filename!)
            }
        })
        let btnCancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
        
        saveController.addAction(btnSave)
        saveController.addAction(btnCancel)
        present(saveController, animated: true, completion: nil)
    }
    
    @IBAction func btnShare(_ sender: Any) {
    }
    
    //----------------------------------------------- Edit Score -----------------------------------------------//
    
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
    

    
    

    
    
    //----------------------------------------------- Table View -----------------------------------------------//
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "player", for: indexPath)
        let person = playerList[indexPath.row]
        tableView.separatorColor = UIColor.init(red: 0.09, green: 0.51, blue: 0.57, alpha: 0)
        configureText(for: cell, with: person)
        configureScore(for: cell, with: person)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        tableView.separatorColor = UIColor.init(red: 0.09, green: 0.51, blue: 0.57, alpha: 0)
        return playerList.count
    }
    
    // Delete Player
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            playerList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    

    
    
    //----------------------------------------------- Auxilliary Functions -----------------------------------------------//
    
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
    
    func configureText(for cell: UITableViewCell, with item: Player) {
        
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = item.name
    }
    
    func configureScore(for cell: UITableViewCell, with item: Player) {
        
        let score = cell.viewWithTag(1001) as! UILabel
        score.text = "\(item.score)"
    }
    
    
    
    //----------------------------------------------- Application Life Cycle -----------------------------------------------//
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        Thread.sleep(forTimeInterval: 5.0)
        return true
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }


}
