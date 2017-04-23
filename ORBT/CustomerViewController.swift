//
// HostViewController.swift
//
// Copyright 2017 Handsome LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

import UIKit
import InteractiveSideMenu

class CustomerViewController: MenuContainerViewController {
    
    var index = 3
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuViewController = self.storyboard!.instantiateViewController(withIdentifier: "CustomerNavigationMenu") as! CustomerNavigationMenu
        
        contentViewControllers = contentControllers()
        
        selectContentViewController(contentViewControllers.first!)
    }
    
    override func menuTransitionOptionsBuilder() -> TransitionOptionsBuilder? {
        return TransitionOptionsBuilder() { builder in
            builder.duration = 0.5
            builder.contentScale = 1
        }
    }
    
    private func contentControllers() -> [MenuItemContentViewController] {
        var contentList = [MenuItemContentViewController]()
        contentList.append(self.storyboard?.instantiateViewController(withIdentifier: "NewRequestViewController") as! MenuItemContentViewController)
        var vc0 = self.storyboard?.instantiateViewController(withIdentifier: "JobViewController") as! JobViewController
        vc0.mStatus = 0
        vc0.mIsCustomer = 1
        
        var vc1 = self.storyboard?.instantiateViewController(withIdentifier: "JobViewController") as! JobViewController
        vc1.mStatus = 1
        vc1.mIsCustomer = 1

        var vc2 = self.storyboard?.instantiateViewController(withIdentifier: "JobViewController") as! JobViewController
        vc2.mStatus = 2
        vc2.mIsCustomer = 1

        contentList.append(vc0)
        contentList.append(vc1)
        contentList.append(vc2)
        return contentList
    }
    
    func dismissSelf() {
        self.dismiss(animated: true, completion: nil)
    }
}
