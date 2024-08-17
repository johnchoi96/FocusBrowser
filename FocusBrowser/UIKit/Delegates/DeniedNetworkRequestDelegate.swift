//
//  DeniedNetworkRequestDelegate.swift
//  MyBrowser
//
//  Created by John Choi on 5/11/22.
//  Copyright © 2022 John Choi. All rights reserved.
//

import Foundation

protocol DeniedNetworkRequestDelegate {

    func didAllowUrl(url: String)
}
