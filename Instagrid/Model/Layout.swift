//
//  PhotoLayout.swift
//  Instagrid
//
//  Created by Nathan on 04/02/2020.
//  Copyright © 2020 Nathan. All rights reserved.
//

import Foundation

class Layout {
    static let layouts = [
        Layout(top: 1, bot: 2),
        Layout(top: 2, bot: 1),
        Layout(top: 2, bot: 2)
    ]
    var top: Int
    var bot: Int
    init(top: Int, bot: Int) {
        self.top = top
        self.bot = bot
    }
}
