///**

/**
 
 RxSwift-Playground
 
 Created by: Nathan Furman on 1/11/18
 Email: ncfusn@gmail.com
 Copyright (c) 2018 Nathan Furman, All Rights Recerved
 
 */

import UIKit

class FSMainTableViewController: UITableViewController {
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Topics"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //
    }
 
}
