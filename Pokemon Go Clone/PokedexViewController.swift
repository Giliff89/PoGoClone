//
//  PokedexViewController.swift
//  Pokemon Go Clone
//
//  Created by gina iliff on 9/15/17.
//  Copyright © 2017 gina iliff. All rights reserved.
//

import UIKit

class PokedexViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        cell.textLabel?.text = "Pokemon"
        
        return cell
    }
    
    @IBAction func returnTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
