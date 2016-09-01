//
//  ReposTableViewController.swift
//  github-repo-starring-swift
//
//  Created by Haaris Muneer on 6/28/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class ReposTableViewController: UITableViewController {
    
    let store = ReposDataStore.sharedInstance
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.tableView.accessibilityLabel = "tableView"
        self.tableView.accessibilityIdentifier = "tableView"
        
        store.getRepositoriesWithCompletion{
            NSOperationQueue.mainQueue().addOperationWithBlock({ 
                self.tableView.reloadData()
            })
        }
    }
    
   
    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.store.repositories.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("repoCell", forIndexPath: indexPath)

        let repository:GithubRepository = self.store.repositories[indexPath.row]
        cell.textLabel?.text = repository.fullName

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        let selectedRepo = store.repositories[indexPath.row]
        
       store.toggleStarStatusForRepository(selectedRepo) { (starred) in
        
            if starred == true
            {
                let unstarAlert = UIAlertController.init(title: "Repository UnStarred", message: "This Repository was Starred before. You have just UnStarred this Repository", preferredStyle: .Alert)
                
                let okButton = UIAlertAction.init(title: "OK", style: .Default, handler: { (action) in
                })
                unstarAlert.addAction(okButton)
                
                self.presentViewController(unstarAlert, animated: true, completion: nil)
            }
            else
            {
                let starAlert = UIAlertController.init(title: "Repository Starred", message: "This Repository was unstarred before. You have just Starred this Repository", preferredStyle: .Alert)
                
                let okButton = UIAlertAction.init(title: "OK", style: .Default, handler: { (action) in
                })
                starAlert.addAction(okButton)
                
                self.presentViewController(starAlert, animated: true, completion: nil)
            }
        }
    }
}
