//
//  CompoundMessageViewController.swift
//  MyInst
//
//  Created by hoatruong on 8/5/19.
//  Copyright © 2019 hoatruong. All rights reserved.
//

import UIKit

class CompoundMessageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableBoxMessage: UITableView!
    
    private var tableData = [[],[]]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableData.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
    }
    
    private func initialTableBoxMessage() {
        
        tableBoxMessage.delegate = self
        tableBoxMessage.dataSource = self
    }

    @IBAction func buttonChatClicked(_ sender: Any) {
        
    }
    
    @IBAction func buttonBackClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
