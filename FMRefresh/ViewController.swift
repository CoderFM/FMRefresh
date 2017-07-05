//
//  ViewController.swift
//  FMRefresh
//
//  Created by 周发明 on 17/7/5.
//  Copyright © 2017年 周发明. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.tableView.tableFooterView = UIView()
        
        for _ in 0...20 {
           self.items.append("呵呵哒")
        }
        
        self.tableView.fm_footer = FMRefreshFooter(refreshAction: { [weak self] in
            let delay = DispatchTime.now() + DispatchTimeInterval.seconds(2)
            DispatchQueue.main.asyncAfter(deadline: delay, execute: {
                for _ in 0...10 {
                    self?.items.append("呵呵哒")
                    self?.tableView.reloadData()
                }
                self?.tableView.fm_footer?.endRefresh()
            })
        })
        
        self.tableView.fm_header = FMRefreshHeader(refreshAction: { [weak self] in
            let delay = DispatchTime.now() + DispatchTimeInterval.seconds(2)
            DispatchQueue.main.asyncAfter(deadline: delay, execute: {
                self?.tableView.fm_header?.endRefresh()
            })
        })
        
    }
    
    lazy var items: [String] = {
        return [String]()
    }()
    
}


extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel?.text = "\(indexPath.row)"
        return cell
    }
}
