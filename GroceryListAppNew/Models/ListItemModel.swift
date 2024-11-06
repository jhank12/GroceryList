//
//  ListItemModel.swift
//  GroceryListAppNew
//
//  Created by Joshua Hankins on 7/23/24.
//

import Foundation

struct ListItem:Hashable, Identifiable {
    var id:UUID = UUID()
    var itemName:String
    var quantity: Double
    var unit: String
    
    var category:String
    var isChecked:Bool = false

}
