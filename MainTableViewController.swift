//
//  MainTableViewController.swift
//  Score
//
//  Created by Madeline Eckhart on 1/2/18.
//  Copyright © 2018 MaddGaming. All rights reserved.
//

import UIKit

class MainTableViewController: UITableViewController {

    var playerList: [Player] = []
    
    @IBAction func btnUpdate(_ sender: Any) {
        
        let person = Player()
        person.name = "My Name Here"
        person.score = 0
        let newRowIndex = playerList.count
        
        playerList.append(person)
        
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexpaths = [indexPath]
        tableView.insertRows(at: indexpaths, with: .automatic)
    
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return playerList.count
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
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
