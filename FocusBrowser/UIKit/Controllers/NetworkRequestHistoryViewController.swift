//
//  NetworkRequestHistoryViewController.swift
//  MyBrowser
//
//  Created by John Choi on 4/29/22.
//  Copyright © 2022 John Choi. All rights reserved.
//

import UIKit

class NetworkRequestHistoryViewController: UIViewController {

    var networkService: NetworkService!

    var delegate: DeniedNetworkRequestDelegate?

    @IBOutlet weak var table: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        table.delegate = self
        table.dataSource = self
        table.register(DeniedURLTableViewCell.nib, forCellReuseIdentifier: DeniedURLTableViewCell.identifier)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        super.overrideUserInterfaceStyle = .dark
        super.navigationController?.overrideUserInterfaceStyle = .dark
        super.tabBarController?.overrideUserInterfaceStyle = .dark
    }
}

extension NetworkRequestHistoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return networkService.deniedUrls.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DeniedURLTableViewCell.identifier) as! DeniedURLTableViewCell
        cell.deniedUrlLabel.text = networkService.deniedUrls[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        // load the URL and dismiss this view
        delegate?.didAllowUrl(url: networkService.deniedUrls[indexPath.row])
        self.dismiss(animated: true)
    }
}
