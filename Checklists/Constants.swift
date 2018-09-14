//
//  Constants.swift
//  Checklists
//
//  Created by chinny ponnoose on 14/09/18.
//  Copyright © 2018 Chinny Ponnooose. All rights reserved.
//

import Foundation

enum SegueIdentifiers: String {
    case ShowChecklist = "ShowChecklist"
    case AddChecklist =  "AddChecklist"
    case AddItem = "AddItem"
    case EditItem = "EditItem"
    case PickItem = "PickIcon"
}

enum CellIdentifiers: String {
    case AllList = "Cell"
    case CheckList = "ChecklistItem"
    case IconCell  = "IconCell"
}

enum Subtitle:String {
    case AllDone = "All Done!"
    case None =  "(No Items)"
}

enum ControllerIdentifier :String {
    case ListDetail = "ListDetailViewController"
}
