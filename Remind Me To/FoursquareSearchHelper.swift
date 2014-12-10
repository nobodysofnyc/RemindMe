//
//  FoursquareSearchHelper.swift
//  Remind Me To
//
//  Created by Mike Kavouras on 12/9/14.
//  Copyright (c) 2014 Mike Kavouras. All rights reserved.
//

import UIKit
import CoreLocation

typealias JSON = Dictionary<String, AnyObject>
typealias FoursquareSuccessCallback = (response: [JSON]?) -> Void

struct FoursquareSearchHelper {
    func performSearch(query: String, location: CLLocation, successCallback: FoursquareSuccessCallback) -> NSURLSessionDataTask {
        let clientId = "5E5S0DUICZZQOHV5TILO0SDY1M0EQYBPYQUE22L1SFR35F0W"
        let clientSecret = "LZXI4QOWMTSNRHCOV4OD3BXBRSS5PQME2NB0BPOMTMECC1JX"
        let baseString = apiBaseURLString()
        let queryString = encodedQueryString(query)
        
        let params = [
            "query" : queryString,
            "ll" : "\(location.coordinate.latitude), \(location.coordinate.longitude)",
            "client_id" : clientId,
            "client_secret" : clientSecret,
            "v" : timestamp()
        ]
        
        let task: NSURLSessionDataTask = AFHTTPSessionManager().GET(baseString, parameters: params, success: { (task: NSURLSessionDataTask!, response: AnyObject!) -> Void in

//            if let resp: JSON = response["response"] as? JSON {
//                if var venues: [JSON] = resp["venues"] as? [JSON] {
//                    successCallback(response: venues)
//                }
//            }
            
            if let resp: JSON = response["response"] as? JSON {
                if let venues: [JSON] = resp["venues"] as? [JSON] {
                    successCallback(response: venues)
                }
            }
            
            }) { (task: NSURLSessionDataTask!, error: NSError!) -> Void in
                
                println(error.userInfo)
        }
        
        return task
    }
    
    private func encodedQueryString(query: String) -> String {
        return query.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
    }
    
    private func apiBaseURLString() -> String {
        return "https://api.foursquare.com/\(version())/venues/search"
    }
    
    private func version() -> String {
        return "v2"
    }
    
    private func timestamp() -> String {
        let components = NSCalendar.currentCalendar().components(.CalendarUnitDay | .CalendarUnitMonth | .CalendarUnitYear, fromDate: NSDate())
        let year = components.year
        let month = String(format: "%02d", components.month)
        var day = String(format: "%02d", components.day)
        return "\(year)\(month)\(day)"
    }
}

