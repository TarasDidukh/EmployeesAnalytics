//
//  PickPositionsView.swift
//  EmployeesAnalytics
//
//  Created by Taras Didukh on 5/24/18.
//  Copyright © 2018 Taras Didukh. All rights reserved.
//

import UIKit

class PickPositionsView: UITableViewController {
    public var viewModel: PickPositionsViewModeling?
    public var selectedPositions: [String] {
        set {
            viewModel?.selectedPositions = newValue
        }
        get {
            return viewModel?.selectedPositions ?? []
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.activityIndicator(true)
        bindView()
        tableView.bounces = false
    }
    
    private func bindView() {
        if let viewModel = viewModel {
            viewModel.positionItems.producer
                .on(value: { roles in
                    self.view.activityIndicator(false)
                    if roles.isEmpty {
                        self.view.emptyList(true, NSLocalizedString("PositionsEmpty", comment: ""))
                    } else {
                        self.view.emptyList(false)
                    }
                    self.tableView.reloadData()
                })
                .start()
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let viewModel = viewModel {
            return viewModel.positionItems.value.count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pickPositionCell", for: indexPath) as! PositionItem
        
        cell.viewModel = viewModel?.positionItems.value[indexPath.row]
        
        return cell
    }
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel?.positionSelected(index: indexPath.row)
    }


}
