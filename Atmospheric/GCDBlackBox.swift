//
//  GCDBlackBox.swift
//  Atmospheric
//
//  Created by Casey Wilcox on 2/2/17.
//  Copyright © 2017 Casey Wilcox. All rights reserved.
//

import Foundation

func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
    DispatchQueue.main.async {
        updates()
    }
}
