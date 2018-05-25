//
//  PickPositionsView.swift
//  EmployeesAnalytics
//
//  Created by Taras Didukh on 5/24/18.
//  Copyright © 2018 Taras Didukh. All rights reserved.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift
import Result

class PickPositionsView: UITableViewController {
    public var resultViewDelegate: ResultViewDelegate?
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
        navigationItem.rightBarButtonItem?.tintColor = AppColors.MainBlue
        navigationItem.title = NSLocalizedString("AddPosition", comment: "")
        tableView.tableFooterView = UIView()
    }
    
    private func bindView() {
        if let viewModel = viewModel {
            viewModel.positionItems.signal
                .observeValues({ roles in
                    self.view.activityIndicator(false)
                    if roles.isEmpty {
                        self.view.emptyList(true, NSLocalizedString("PositionsEmpty", comment: ""))
                    } else {
                        self.view.emptyList(false)
                    }
                    self.tableView.reloadData()
                })
        }
        
        navigationItem.leftBarButtonItem?.reactive.pressed = CocoaAction(Action<(), (), NoError>(execute: { _ in
            return SignalProducer { observer, disposable in
                self.dismiss(animated: true, completion: nil)
                observer.sendCompleted()
            }
        }))
        
        navigationItem.rightBarButtonItem?.reactive.pressed = CocoaAction(Action<(), (), NoError>(execute: { _ in
            return SignalProducer { observer, disposable in
                if let viewModel = self.viewModel {
                    self.resultViewDelegate?.send(result: viewModel.selectedPositions)
                }
                self.dismiss(animated: true, completion: nil)
                observer.sendCompleted()
            }
        }))
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let viewModel = viewModel {
            if !viewModel.positionItems.value.isEmpty {
                self.view.emptyList(false)
                self.view.activityIndicator(false)
            }
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
