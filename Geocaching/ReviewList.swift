//
//  ReviewList.swift
//  Geocaching
//
//  Created by Abdallah Abuhashem on 2/3/20.
//  Copyright © 2020 Abdallah AbuHashem. All rights reserved.
//

import UIKit

var items = [
    ["labelText": "First Item", "lat": 37.429702, "long": -122.173025],
    ["labelText": "Second Item", "lat": 37.429161, "long": -122.173380],
    ["labelText": "Third Item", "lat": 37.428653, "long": -122.173551],
    ["labelText": "Fourth Item", "lat": 37.428308, "long": -122.173363],
    ["labelText": "Fifth Item", "lat": 37.428104, "long": -122.174007],
    ["labelText": "Sixth Item", "lat": 37.427695, "long": -122.173926],
    ["labelText": "Seventh Item", "lat": 37.427469, "long": -122.173792],
    ["labelText": "Eighth Item", "lat": 37.427073, "long": -122.173916],
    ["labelText": "Nineth Item", "lat": 37.426756, "long": -122.174030],
    ["labelText": "Tenth Item", "lat": 37.426257, "long": -122.173778],
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
