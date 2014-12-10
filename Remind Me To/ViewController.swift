//
//  ViewController.swift
//  Remind Me To
//
//  Created by Mike Kavouras on 12/9/14.
//  Copyright (c) 2014 Mike Kavouras. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    
    let clientId = "5E5S0DUICZZQOHV5TILO0SDY1M0EQYBPYQUE22L1SFR35F0W"
    
    let clientSecret = "LZXI4QOWMTSNRHCOV4OD3BXBRSS5PQME2NB0BPOMTMECC1JX"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func submitTapped(sender: AnyObject) {
        performSearch()
    }
    
    private func performSearch() {
        AFHTTPSessionManager().GET(apiURLString(), parameters: nil, success: { (task: NSURLSessionDataTask!, response: AnyObject!) -> Void in
            
            }) { (task: NSURLSessionDataTask!, error: NSError!) -> Void in
                
        }
        //https://api.foursquare.com/v2/venues/search?ll=40.663198,-73.988149&query=e&amph&client_id=5E5S0DUICZZQOHV5TILO0SDY1M0EQYBPYQUE22L1SFR35F0W&client_secret=&v=20141210

    }
    
    private func apiURLString() -> String {
        return "\(apiBaseURLString())?ll=\(locationParams())&query=\(queryString())&client_id=\(clientId)&client_secret=\(clientSecret)&v=\(timestamp())"
    }
    
    private func locationParams() -> String {
        
    }
    
    private func queryString() -> String {
        return textField.text.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
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

