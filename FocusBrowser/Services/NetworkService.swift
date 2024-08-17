//
//  NetworkService.swift
//  MyBrowser
//
//  Created by John Choi on 4/29/22.
//  Copyright © 2022 John Choi. All rights reserved.
//

import Foundation

/// Returns true or false if the next URL should be loaded or not.
/// Only allows URL domain after the very first domain loaded.
class NetworkService {

    let originalAllowedDomainSize: Int!
    var allowedDomainSize: Int
    var deniedUrls: [String]

    /// this will contain the domain only. i.e. google.com
    private var allowedDomains: Set<String>
    private var homeDomain: String? // first loading page

    init(allowedDomainSize: Int = 2) {
        allowedDomains = Set<String>()
        deniedUrls = [String]()
        self.allowedDomainSize = allowedDomainSize
        originalAllowedDomainSize = allowedDomainSize
    }

    /// Resets allowedDomains, allowedDomainSize, and deniedUrls.
    private func reset() {
        allowedDomains = Set<String>()
        allowedDomains.insert(homeDomain!)
        allowedDomainSize = originalAllowedDomainSize
        deniedUrls = [String]()
    }

    /// Returns true if the passed in URL should be loaded.
    /// - Parameter absolutePath: full URL in String. i.e. https://www.google.com/foo/bar/
    /// - Returns true if this URL should be loaded, false otherwise
    func shouldLoadUrl(absolutePath: String) -> Bool {
        // see if the absolute path is the first network request
        let pathDomain = extractDomain(from: absolutePath)
        if let homeDomain = homeDomain {
            // if trying to load home domain, do not need to check anything else
            if homeDomain == pathDomain {
                reset()
                return true
            }
        } else {
            // first load
            homeDomain = pathDomain
            allowedDomains.insert(homeDomain!)
            return true
        }

        if allowedDomains.count < allowedDomainSize {
            allowedDomains.insert(pathDomain)
            return true
        }
        // if no more space to fill, check if absolutePath is in allowedDomains
        if allowedDomains.contains(pathDomain) {
            return true
        }
        deniedUrls.append(absolutePath)
        return false
    }

    /// Add the absolutePath's domain to the allowed domain list and remove from the denied list
    func allowDomain(absolutePath: String) {
        // make sure absolutePath's domain doesn't exist in allowedDomains
        let absolutePathDomain = extractDomain(from: absolutePath)
        if allowedDomains.contains(absolutePathDomain) {
            return
        }
        allowedDomainSize += 1
        allowedDomains.insert(absolutePathDomain)

        // if absolutePath exists in the deniedUrls, remove from deniedUrls
        if let firstIndex = deniedUrls.firstIndex(of: absolutePath) {
            deniedUrls.remove(at: firstIndex)
        }
    }

    /// Takes an absolute path for the URL and extracts just the domain.
    func extractDomain(from absolutePath: String) -> String {
        let tokensBySlash = absolutePath.components(separatedBy: "/")
        let fullDomain = tokensBySlash[2]
        let tokensByPeriod = fullDomain.components(separatedBy: ".")
        let domain = tokensByPeriod[tokensByPeriod.count - 2] + "." + tokensByPeriod[tokensByPeriod.count - 1]
        return domain
    }
}
