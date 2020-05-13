//
//  ReviewPOI.swift
//  Geocaching
//
//  Created by Abdallah Abuhashem on 5/13/20.
//  Copyright © 2020 Abdallah AbuHashem. All rights reserved.
//

import UIKit
import GoogleMaps

class ReviewPOI: UIViewController {

    @IBOutlet weak var firstItem: UIView!
    @IBOutlet weak var secondItem: UIView!
    @IBOutlet weak var thirdItem: UIView!
    @IBOutlet weak var fourthItem: UIView!
    @IBOutlet weak var fifthItem: UIView!
    @IBOutlet weak var sixthItem: UIView!
    @IBOutlet weak var seventhItem: UIView!
    @IBOutlet weak var eighthItem: UIView!
    @IBOutlet weak var ninethItem: UIView!
    @IBOutlet weak var tenthItem: UIView!
    var itemsList: [UIView] = []
    var labelsList: [UILabel] = []
    
    func populateLabels() {
        print(items)
        if (labelsList == []) {
            for (index, item) in items.enumerated() {
                let label = UILabel(frame: CGRect(x: 27, y: 17, width: 241, height: 21))
                label.textAlignment = .left
                label.text = item["labelText"] as? String
                self.itemsList[index].addSubview(label)
                self.labelsList.append(label)
            }
        } else {
            for (index, item) in items.enumerated() {
                let label = labelsList[index]
                label.textAlignment = .left
                label.text = item["labelText"] as? String
            }
        }
    }
    
    @IBAction func dismissModal(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.itemsList = [firstItem, secondItem, thirdItem, fourthItem, fifthItem, sixthItem, seventhItem, eighthItem, ninethItem, tenthItem]
        
        populateLabels()
        
        for item in self.itemsList {
            item.layer.applySketchShadow()
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ReviewPOI.itemTapped(gesture:)))
            item.addGestureRecognizer(tapGesture)
            item.isUserInteractionEnabled = true
        }
        // Do any additional setup after loading the view.
    }
    
    @objc func itemTapped(gesture: UIGestureRecognizer) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "ChoosePOI") as! ChoosePOI
        for (index, item) in itemsList.enumerated() {
            if (item == gesture.view) {
                newViewController.delegate = self
                newViewController.receivedIndex = index
                self.present(newViewController, animated: true, completion: nil)
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ReviewPOI: ChangeNameDelegate {
    func changeName(name: String, loc: CLLocationCoordinate2D, index: Int) {
        items[index]["labelText"] = name
        items[index]["lat"] = loc.latitude
        items[index]["long"] = loc.longitude
        populateLabels()
        self.dismiss(animated: true, completion: nil)
    }
}
