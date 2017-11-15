//
//  HistoryTableViewController.swift
//  SecondTour
//
//  Created by Gena Beraylik on 12.11.2017.
//  Copyright © 2017 Beraylik. All rights reserved.
//

import UIKit
import CoreData

struct VoyageStruct {
    init(voyage: Voyagers) {
        self.date = (voyage.date ?? nil)!
        self.field = voyage.field ?? "EMPTY"
        self.score = Int(voyage.score)
        self.path = voyage.path ?? "EMPTY"
    }
    
    var path: String
    var field: String
    var date: Date
    var score: Int
    
}

class HistoryTableViewController: UITableViewController {

    let cellID = "CellID"
    var voyagers: [Voyagers] = []
    var voyagerStr: [VoyageStruct] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.navigationItem.largeTitleDisplayMode = .always
        self.navigationItem.title = "History"
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        loadFromDB()
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        loadFromDB()
    }
    
    func loadFromDB() {
        let context = AppDelegate().persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Voyagers")
        //voyagers = Voyagers.fetchRequest()
        
        do {
            voyagers = (try context.fetch(fetchRequest) as? [Voyagers])!
            var arr: [VoyageStruct] = []
            for item in voyagers {
                arr.append(VoyageStruct.init(voyage: item))
            }
            voyagerStr = arr
            voyagerStr.sort(by: {$0.date > $1.date})
        } catch let error {
            print(error.localizedDescription)
        }
        tableView.reloadData()
        
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
        return voyagerStr.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = HistoryTableViewCell(style: .default, reuseIdentifier: cellID)
        let voyager = voyagerStr[indexPath.row]
        let date = voyager.date as Date
        let dateFormatter = DateFormatter.localizedString(from: date, dateStyle: .short, timeStyle: .short)
        cell.dateLabel.text = dateFormatter
        cell.pathLabel.text = voyager.path
        
        //cell.textLabel?.text = "\(dateFormatter): \(voyager.path!)"
        // Configure the cell..
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailsView = DetailsViewController()
        detailsView.voyagerStr = voyagerStr[indexPath.row]
        navigationController?.pushViewController(detailsView, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        /*
        if editingStyle == .delete {
            let context = AppDelegate().persistentContainer.viewContext
            let value = voyagerStr[indexPath.row]
            print(value)
            context.delete(value)
            
            do {
                if context.hasChanges {
                    try context.save()
                }
            } catch let error {
                print(error.localizedDescription)
            }
            loadFromDB()
            //tableView.reloadData()
        }
        */
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
