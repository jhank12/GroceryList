//
//  GroceryViewModel.swift
//  GroceryListAppNew
//
//  Created by Joshua Hankins on 7/25/24.
//

import Foundation
import CoreData

struct GroceryCategoryStruct {
    
    var categoryName:String
    var iconName:String
    
}

class GroceryViewModel:ObservableObject {
    
    var groceryCategories:[String] =
    ["Protein", "Fruit", "Vegetables", "Dairy", "Grains", "Snacks", "Drinks"]
    
    
    var categoryIcons:[String: String] = [
        "Protein": "meat_icon3",
        "Fruit": "banana_icon",
        "Vegetables": "broccoli_icon",
        "Dairy": "milk_icon",
        "Grains": "bread_icon",
        "Snacks": "snack_icon2",
        "Drinks": "soda_icon",

    ]
    
    
    //    var groceryItems:[String: [String]] =
    //    [
    //
    //        "Meat": ["Ground Beef", "Chicken", "Fish", "Steak", "Turkey", "Lamb"],
    //        "Fruit": ["Apples", "Oranges", "Bananas", "Grapes", "Pineapple"],
    //        "Vegetables": ["Broccoli", "Carrots", "Tomatos"],
    //        "Dairy": ["Milk", "Cream Cheese", "Yogurt"],
    //        "Drinks": ["Soda", "Water", "Juice"]
    //
    //    ]
    
    let container:NSPersistentContainer
    
    init() {
        container = NSPersistentContainer(name: "GroceryContainer")
        container.loadPersistentStores{(description, error) in
            
            if let error {
                print(error)
            } else {
                print("load grocery container successufully")
            }
            
        }
        
        fetchCustomItems()
    }
    
    //    put custom items at top of category view
    
    @Published var customItems:[String: [GroceryItemStruct]] = [:]
    var items:[CustomItemEntity] = []
    
    
//    sort newest to oldest
    func fetchCustomItems() {
        customItems = [:]
        
        items.sorted{$0.date ?? .now > $1.date ?? .now}
        
        do {
            items = try container.viewContext.fetch(NSFetchRequest<CustomItemEntity>(entityName: "CustomItemEntity"))
        } catch {
            print(error)
        }
        
        for item in items {
            
            let convertedItem:GroceryItemStruct = GroceryItemStruct(name: item.itemName ?? "", category: item.category ?? "", isCustomItem:true)
            
            if Array(customItems.keys).contains(item.category ?? "") {
                customItems[item.category ?? ""]?.append(convertedItem)

            } else {
                customItems[item.category ?? ""] = []
                
                customItems[item.category ?? ""]?.append(convertedItem)
                
            }
            
        }
 
    }
    
    func createCustomItem(item:GroceryItemStruct) {
        let itemName = item.name
        let category = item.category
        
        let newItem:CustomItemEntity = CustomItemEntity(context: container.viewContext)
        
        newItem.itemName = itemName
        newItem.category = category
        newItem.date = .now
        
        save()
    }
    
//    custom items in category view should have swipe action to edit name
//    func editCustomItem(item: GroceryItemStruct, oldItemName:String) {
    func editCustomItem(updatedItemName: String, oldItemName:String) {
       
        
        let itemEntity:CustomItemEntity = items.filter{$0.itemName == oldItemName}[0]
        
        itemEntity.itemName = updatedItemName
        
        container.viewContext.refreshAllObjects()
        save()
        
    }
    
    func itemExists(itemName:String)->Bool {
        let customItemEntity:[CustomItemEntity] = items.filter{$0.itemName == itemName}
        
        if customItemEntity.count > 0 {
            return true
        } else {
            return false
        }

        
    }

    
    func deleteCustomItem(customItemName:String){

        let customItemEntity:CustomItemEntity = items.filter{$0.itemName == customItemName}[0]
        
        container.viewContext.delete(customItemEntity)
        save()
        
    }
    
    func save() {
        do {
            try container.viewContext.save()
            fetchCustomItems()
        } catch {
            print(error)
        }
        
    }
    
    var regularUnitsArr:[String] = ["x","lb", "oz"]
    var liquidUnitsArr:[String] = ["gal", "L", "oz", "x"]
    
    func addCustomItem(item: ListItem) {
        let newGroceryItem:GroceryItemStruct = GroceryItemStruct(name: item.itemName, category: item.category)
        
        groceryItems[item.category]?.append(newGroceryItem)
    }

    @Published var groceryItems:[String:[GroceryItemStruct]] = [

        "Protein": [
            GroceryItemStruct(name: "Ground Beef", category: "Protein"),
            GroceryItemStruct(name: "Chicken", category: "Protein"),
            GroceryItemStruct(name: "Fish", category: "Protein"),
            GroceryItemStruct(name: "Steak", category: "Protein"),
            GroceryItemStruct(name: "Turkey", category: "Protein"),
            GroceryItemStruct(name: "Lamb", category: "Protein"),
            GroceryItemStruct(name: "Beef Jerky", category: "Protein"),
            GroceryItemStruct(name: "Eggs", category: "Protein"),
            GroceryItemStruct(name: "Beans", category: "Protein"),
        ],
        "Fruit": [
            GroceryItemStruct(name: "Apples", category: "Fruit"),
            GroceryItemStruct(name: "Oranges", category: "Fruit"),
            GroceryItemStruct(name: "Bananas", category: "Fruit"),
            GroceryItemStruct(name: "Strawberries", category: "Fruit"),
            GroceryItemStruct(name: "Watermelon", category: "Fruit"),
            GroceryItemStruct(name: "Grapes", category: "Fruit"),
            GroceryItemStruct(name: "Blueberries", category: "Fruit"),
            GroceryItemStruct(name: "Raspberries", category: "Fruit"),
            GroceryItemStruct(name: "Pineapple", category: "Fruit"),
            GroceryItemStruct(name: "Kiwi", category: "Fruit"),
            
        ],
        "Vegetables": [
            GroceryItemStruct(name: "Broccoli", category: "Vegetables"),
            GroceryItemStruct(name: "Corn", category: "Vegetables"),
            GroceryItemStruct(name: "Tomato", category: "Vegetables"),
            GroceryItemStruct(name: "Potato", category: "Vegetables"),
            GroceryItemStruct(name: "Green Beans", category: "Vegetables"),
            GroceryItemStruct(name: "Carrot", category: "Vegetables"),
            GroceryItemStruct(name: "Peppers", category: "Vegetables"),
            GroceryItemStruct(name: "Garlic", category: "Vegetables"),
            GroceryItemStruct(name: "Onion", category: "Vegetables"),
            GroceryItemStruct(name: "Sweet Potato", category: "Vegetables"),
            GroceryItemStruct(name: "Lettuce", category: "Vegetables"),
            GroceryItemStruct(name: "Asparagus", category: "Vegetables"),
            GroceryItemStruct(name: "Avocado", category: "Vegetables"),
            GroceryItemStruct(name: "Cauliflower", category: "Vegetables"),
        ],
        "Dairy": [
            GroceryItemStruct(name: "Milk", category: "Dairy"),
            GroceryItemStruct(name: "Yogurt", category: "Dairy"),
            GroceryItemStruct(name: "Cheese", category: "Dairy"),
            GroceryItemStruct(name: "Butter", category: "Dairy"),
            GroceryItemStruct(name: "Cream", category: "Dairy"),
            GroceryItemStruct(name: "Sour Cream", category: "Dairy"),
            GroceryItemStruct(name: "Ice Cream", category: "Dairy"),
        ],
        "Grains": [
            GroceryItemStruct(name: "Bread", category: "Grains"),
            GroceryItemStruct(name: "Cereal", category: "Grains"),
            GroceryItemStruct(name: "Tortilla", category: "Grains"),
            GroceryItemStruct(name: "Pasta", category: "Grains"),
            GroceryItemStruct(name: "Oatmeal", category: "Grains"),
            GroceryItemStruct(name: "Rice", category: "Grains"),
            GroceryItemStruct(name: "Quinoa", category: "Grains"),
        ],
        "Snacks": [
            GroceryItemStruct(name: "Chips", category: "Snacks"),
            GroceryItemStruct(name: "Popcorn", category: "Snacks"),
            GroceryItemStruct(name: "Pretzels", category: "Snacks"),
            GroceryItemStruct(name: "Trail Mix", category: "Snacks"),
            GroceryItemStruct(name: "Nuts", category: "Snacks"),
            GroceryItemStruct(name: "Cookies", category: "Snacks"),
        ],
        "Drinks": [
            GroceryItemStruct(name: "Soda", category: "Drinks"),
            GroceryItemStruct(name: "Water", category: "Drinks"),
            GroceryItemStruct(name: "Sports Drink", category: "Drinks"),
            GroceryItemStruct(name: "Tea", category: "Drinks"),
            GroceryItemStruct(name: "Juice", category: "Drinks"),
            GroceryItemStruct(name: "Coffee", category: "Drinks"),
            GroceryItemStruct(name: "Alcohol", category: "Drinks"),
            GroceryItemStruct(name: "Energy Drink", category: "Drinks"),
        ]
        
    ]
    
}
