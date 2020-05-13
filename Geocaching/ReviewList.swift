//
//  ReviewList.swift
//  Geocaching
//
//  Created by Abdallah Abuhashem on 2/3/20.
//  Copyright © 2020 Abdallah AbuHashem. All rights reserved.
//

import UIKit

var items = [
    ["labelText": "Gates Fountain", "teamName": "Green Bay Packers", "lat": 37.429702, "long": -122.173025, "location_sound": "Gates_Fountain", "team_sound": "Green_Bay_Packers", "resource": "packers"],
    ["labelText": "Hewlett Building", "teamName": "Green Bay Packers", "lat": 37.42956435326761, "long": -122.1725258569226, "location_sound": "Hewlett_Building", "team_sound": "Green_Bay_Packers", "resource": "packers"],
    ["labelText": "Herrin Hall", "teamName": "New York Jets", "lat": 37.42940939177343, "long": -122.1718014835212, "location_sound": "Herrin_Hall", "team_sound": "NewYork_Jets", "resource": "jets"],
    ["labelText": "Math Corner", "teamName": "Kansas City Chiefs", "lat": 37.42926271997531, "long": -122.1712584919556, "location_sound": "Math_Corner", "team_sound": "Kansas_City_Chiefs", "resource": "chiefs"],
    ["labelText": "Jordan Hall", "teamName": "Baltimore Colts", "lat": 37.42910163393704, "long": -122.1707071782287, "location_sound": "Jordan_Hall", "team_sound": "Baltimore_Colts", "resource": "colts"],
    ["labelText": "The Oval", "teamName": "Dallas Cowboys", "lat": 37.428939, "long": -122.169776, "location_sound": "The_Oval", "team_sound": "Dallas_Cowboys", "resource": "cowboys"],
    ["labelText": "Memorial Court", "teamName": "Miami Dolphins", "lat": 37.428562, "long": -122.169902, "location_sound": "Memorial_Court", "team_sound": "Miami_Dolphins", "resource": "dolphins"],
    ["labelText": "Memorial Court Statues", "teamName": "Miami Dolphins", "lat": 37.4280296, "long": -122.1700336, "location_sound": "Memorial_Court_Statues", "team_sound": "Miami_Dolphins", "resource": "dolphins"],
    ["labelText": "Main Quad", "teamName": "Pittsburgh Steelers", "lat": 37.42781225542934, "long": -122.1701390286122, "location_sound": "Main_Quad", "team_sound": "Pittsburgh_Steelers", "resource": "steelers"],
    ["labelText": "Memorial Church", "teamName": "Pittsburgh Steelers", "lat": 37.427297, "long": -122.170324, "location_sound": "Memorial_Church", "team_sound": "Pittsburgh_Steelers", "resource": "steelers"],
]

extension CALayer {
  func applySketchShadow(
    color: UIColor = UIColor(red: 0.726, green: 0.726, blue: 0.726, alpha: 1),
    alpha: Float = 0.5,
    x: CGFloat = 0,
    y: CGFloat = 7,
    blur: CGFloat = 24,
    spread: CGFloat = 0)
  {
    shadowColor = color.cgColor
    shadowOpacity = alpha
    shadowOffset = CGSize(width: x, height: y)
    shadowRadius = blur / 2.0
    if spread == 0 {
      shadowPath = nil
    } else {
      let dx = -spread
      let rect = bounds.insetBy(dx: dx, dy: dx)
      shadowPath = UIBezierPath(rect: rect).cgPath
    }
  }
}

class ReviewList: UIViewController {

    @IBOutlet weak var itemsScrollView: UIScrollView!
    @IBOutlet weak var firstItem: UIView!
    @IBOutlet weak var firstItemHeight: NSLayoutConstraint!
    @IBOutlet weak var secondItem: UIView!
    @IBOutlet weak var secondItemHeight: NSLayoutConstraint!
    @IBOutlet weak var thirdItem: UIView!
    @IBOutlet weak var thirdItemHeight: NSLayoutConstraint!
    @IBOutlet weak var fourthItem: UIView!
    @IBOutlet weak var fourthItemHeight: NSLayoutConstraint!
    @IBOutlet weak var fifthItem: UIView!
    @IBOutlet weak var fifthItemHeight: NSLayoutConstraint!
    @IBOutlet weak var sixthItem: UIView!
    @IBOutlet weak var sixthItemHeight: NSLayoutConstraint!
    @IBOutlet weak var seventhItem: UIView!
    @IBOutlet weak var seventhItemHeight: NSLayoutConstraint!
    @IBOutlet weak var eighthItem: UIView!
    @IBOutlet weak var eighthItemHeight: NSLayoutConstraint!
    @IBOutlet weak var ninethItem: UIView!
    @IBOutlet weak var ninethItemHeight: NSLayoutConstraint!
    @IBOutlet weak var tenthItem: UIView!
    @IBOutlet weak var tenthItemHeight: NSLayoutConstraint!
    
    var itemsList: [UIView] = []
    var heightsList: [NSLayoutConstraint] = []
    var labelsList: [UILabel] = []
    
    var tapped = false
    var extendedIndex = -1
    
    @IBAction func dismissModal(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func populateLabels() {
        for (index, item) in items.enumerated() {
            let label = UILabel(frame: CGRect(x: 27, y: 17, width: 241, height: 21))
            label.textAlignment = .left
            label.text = item["labelText"] as? String
            self.itemsList[index].addSubview(label)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.itemsList = [firstItem, secondItem, thirdItem, fourthItem, fifthItem, sixthItem, seventhItem, eighthItem, ninethItem, tenthItem]
        self.heightsList = [firstItemHeight, secondItemHeight, thirdItemHeight, fourthItemHeight, fifthItemHeight, sixthItemHeight, seventhItemHeight, eighthItemHeight, ninethItemHeight, tenthItemHeight]
        populateLabels()
        
        for item in self.itemsList {
            item.layer.applySketchShadow()
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ReviewList.itemTapped(gesture:)))
            item.addGestureRecognizer(tapGesture)
            item.isUserInteractionEnabled = true
        }
        
    }
    
    @objc func itemTapped(gesture: UIGestureRecognizer) {
        for (index, item) in itemsList.enumerated() {
            if (item == gesture.view) {
                print(itemsScrollView.contentSize)
                if (!tapped) {
                    itemsScrollView.contentSize = CGSize(width: 375, height: 1000)
                    tapped = true
                    UIView.animate(withDuration: 0.5, animations: {
                        self.heightsList[index].constant = self.heightsList[index].constant + 300 // heightCon is the IBOutlet to the constraint
                        self.view.layoutIfNeeded()
                    })
                    extendedIndex = index
                } else {
                    itemsScrollView.contentSize = CGSize(width: 375, height: 700)
                    tapped = false
                    UIView.animate(withDuration: 0.5, animations: {
                        self.heightsList[self.extendedIndex].constant = self.heightsList[self.extendedIndex].constant - 300 // heightCon is the IBOutlet to the constraint
                        self.view.layoutIfNeeded()
                    })
                    extendedIndex = -1
                }
            }
        }
    }

}
