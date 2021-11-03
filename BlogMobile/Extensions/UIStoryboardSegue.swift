//
//  ExtUIStoryboardSegue.swift
//  BlogMobile
//
//  Created by gunhyeong on 2021/11/03.
//

import UIKit

class SlideLeft: UIStoryboardSegue {
  override func perform() {
    self.source.view.superview?.insertSubview(self.destination.view, aboveSubview: self.source.view)
    self.destination.view.frame.origin.x = self.source.view.frame.size.width
    UIView.animate(withDuration: 0.25, animations: {
      self.destination.view.frame.origin.x = 0
    }) { (finished) in
      self.source.present(self.destination, animated: false, completion: nil)
    }
  }
}
