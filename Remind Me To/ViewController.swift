//
//  ViewController.swift
//  Remind Me To
//
//  Created by Mike Kavouras on 12/9/14.
//  Copyright (c) 2014 Mike Kavouras. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate, UITextFieldDelegate, UITextViewDelegate {

    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var textViewHeightConstraint: NSLayoutConstraint!
    
    let CellIdentifier = "CellIdentifier"
    
    var location = CLLocation()
    
    var search: NSURLSessionDataTask?
    
    var places: [JSON]?
    
    lazy var locationManager: CLLocationManager = {
        var manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.distanceFilter = 0
       return manager
    }()
    
    override func viewDidLoad() {
        searchDisplayController?.searchResultsTableView.registerNib(UINib(nibName: "SearchCell", bundle: nil), forCellReuseIdentifier: CellIdentifier)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if locationManager.respondsToSelector("requestWhenInUseAuthorization") {
            locationManager.requestWhenInUseAuthorization()
        }
        locationManager.startUpdatingLocation()
    }
    
    @IBAction func submitTapped(sender: AnyObject) {
        performSearch()
    }
    
    private func performSearch() {
        
        if let s = search {
            s.cancel()
        }
        
        search = FoursquareSearchHelper().performSearch(searchBar.text, location: location, successCallback: {(response: [JSON]?) -> Void in
            if let resp = response {
                self.places = resp
                println(self.places?.count)
            }
        })
    }
    
    
    // MARK: <CLLocationManagerDelegate>
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        location = locations[0] as CLLocation
    }

    
    // MARK: <UITextFieldDelegate>
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
//        performSearch()

        return true
    }
    
    func textViewDidChange(textView: UITextView) {
        textView.layoutManager.ensureLayoutForTextContainer(textView.textContainer)
        textView.layoutIfNeeded()
        
        let contentSize = textView.contentSize
        println(contentSize.height)
        
        textViewHeightConstraint.constant = contentSize.height
        textView.contentOffset = CGPoint(x: 0, y: 0)
        textView.contentInset = UIEdgeInsetsZero
    }

}

