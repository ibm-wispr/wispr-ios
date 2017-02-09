//
//  ListEmailTableViewController.swift
//  WISPr
//
//  Created by Brian Cheng on 2/7/17.
//  Copyright © 2017 Brian Cheng. All rights reserved.
//  Disclosure, not any of my code.  Copied from various chunks of code found on the internet

import UIKit
import Foundation


class ListEmailTableViewController: UITableViewController {
    
    var items = [[String: Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getjson()
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
        return self.items.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        // Configure the cell...
 //       print(self.items[indexPath.row]["subject"]);
        if let subject = self.items[indexPath.row]["subject"] as? String {
            cell.textLabel?.text = subject
        } else {
            cell.textLabel?.text = "No Subject"
        }
        return cell
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
            let destination = segue.destination as? EmailViewController
            var email = self.items[(self.tableView.indexPathForSelectedRow?.row)!]
            destination?.from = email["from"] as! String
            destination?.subject = email["subject"] as! String
            destination?.messageId = email["messageId"] as! String
    }
    

    
    func getjson() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let url:URL = URL(string: appDelegate.apiURL + "/messages/search?start=0&tag=INBOX")!
        let session = URLSession.shared
        let request = NSMutableURLRequest(url: url)
        request.setValue(appDelegate.jwt_token, forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData

        let task = session.dataTask(with: request as URLRequest, completionHandler: {
            (
            data, response, error) in
            
            guard let _:Data = data, let _:URLResponse = response  , error == nil else {
                
                return
            }
            
            
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as? [String:Any] {
                    //print(json)
                    if let jsonDataArray = json["data"] as?[[String:Any]]{
                        self.items = jsonDataArray
                        //print(self.items)
                        self.tableView.reloadData()

                    }
                }
            } catch let err{
                print(err.localizedDescription)
            }
            
        })
        
        task.resume()
    }
}
