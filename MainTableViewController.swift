//
//  MainTableViewController.swift
//  Score!
//
//  Created by Madeline Eckhart on 1/2/18.
//  Copyright © 2018 MaddGaming. All rights reserved.
//

import UIKit
import CoreData

class MainTableViewController: UITableViewController {

    
    //----------------------------------------------- Navigation Bar Functions -----------------------------------------------//
    
    var playerList: [Player] = []
    var context: NSManagedObjectContext!

    // Add Player
    
    @IBAction func btnNewPlayer(_ sender: Any) {
        let alertController = UIAlertController(title: "Add Player", message: nil, preferredStyle: .alert)
        let alertText = UIAlertAction(title: "Done", style: .default) { (alertAction) in
            let nameTextField = alertController.textFields![0] as UITextField
            self.addPlayer(new_name: nameTextField.text!)
        }
        let alertCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addTextField{ (nameTextField) in
            nameTextField.autocapitalizationType = .words
            nameTextField.placeholder = "Enter Name"
        }
        
        alertController.addAction(alertText)
        alertController.addAction(alertCancel)
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
    
    @IBAction func btnNewGame(_ sender: Any) {
        let alert = UIAlertController(title: "Start New Game", message: "Are you sure?", preferredStyle: .alert)
        alert.view.tintColor = UIColor(red:0.11, green:0.79, blue:1.00, alpha:1.0)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action:UIAlertAction) in
            
        }))
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action:UIAlertAction) in
            
            let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Player")
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
            
            do {
                try self.context.execute(deleteRequest)
                try self.context.save()
                self.fetchData()
            } catch {
                print ("There was an error")
            }
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func btnShare(_ sender: Any) {
        var shareContent = "Players:\n"
        
        for player in playerList {
            shareContent += String(format: "%@ - %ld\n", player.name!, player.score)
        }
        
        let activityViewController = UIActivityViewController(activityItems: [shareContent as NSString], applicationActivities: nil)
        activityViewController.view.tintColor = UIColor(red:0.11, green:0.79, blue:1.00, alpha:1.0)
        
        present(activityViewController, animated: true, completion: {})
    }
    
    
    
    
    
    //------------------------------------------------------------- Data -------------------------------------------------------------//
    
    
    func initCoreData()
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
    }
    
    func fetchData()
    {
        do {
            playerList = try context.fetch(Player.fetchRequest())
            self.tableView.reloadData()
            //checkButtons()
        } catch {
            print("Fetching Failed")
        }
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

        guard let addThis = Int16(num) else {
            let addThis = 0
            return
        }
        
        let currentScore = playerList[index].score
        
        playerList[index].score = (currentScore + addThis)
        
        //core data
        do {
            let indexPath = IndexPath.init(row: index, section: 0)
            try self.context.save()
            self.tableView.beginUpdates()
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
            self.tableView.endUpdates()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }

    }
    

    
    

    
    
    //----------------------------------------------- Table View -----------------------------------------------//
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    
        return " "
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = UIColor.white
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        tableView.separatorColor = UIColor.init(red: 0.09, green: 0.51, blue: 0.57, alpha: 0)
        return playerList.count
    }
    
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "player", for: indexPath)
        let person = playerList[indexPath.row]
        tableView.separatorColor = UIColor.init(red: 0.09, green: 0.51, blue: 0.57, alpha: 0)
        configureText(for: cell, with: person)
        configureScore(for: cell, with: person)
        return cell
    }
    
    
    // Delete Player
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            context.delete(playerList[indexPath.row])
            playerList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        }
        
        // save deletion to core data
        do {
            try self.context.save()
            self.tableView.isHidden = (self.playerList.count == 0) ? true : false
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    

    
    
    //----------------------------------------------- Auxilliary Functions -----------------------------------------------//
    
    func addPlayer(new_name: String) {
        
        let newRowIndex = playerList.count
        let person = Player(context: self.context)
        
        person.name = new_name
        person.score = 0
        if person.name == "" {
            return
        } else {
            playerList.append(person)
        }
        
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexpaths = [indexPath]
        tableView.insertRows(at: indexpaths, with: .automatic)
        
        // saving to core data
        do {
            try self.context.save()
            self.tableView.isHidden = (self.playerList.count == 0) ? true : false
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
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
        
        initCoreData()
        fetchData()
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        Thread.sleep(forTimeInterval: 5.0)
        return true
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }


}
