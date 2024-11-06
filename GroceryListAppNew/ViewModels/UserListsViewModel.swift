//
//  UserListsViewModel.swift
//  GroceryListAppNew
//
//  Created by Joshua Hankins on 7/23/24.
//

import Foundation
import CoreData


class UserListsViewModel: ObservableObject {
    
    @Published var previewList: [String:[ListItem]] = [
        :
    ]
    
    @Published var usersLists:[ListEntity] = []
    
    @Published var savedLists:[SavedListEntity] = []
    
    let container:NSPersistentContainer
    
    
    init() {
        //        container = NSPersistentContainer(name: "UserListsContainer")
        
        container = NSPersistentContainer(name: "UserListsContainer")
        
        container.loadPersistentStores{(description, error) in
            if let error {
                print(error)
//                print("failed loading store")
            } else {
//                print("loaded from store successfully")
            }
        }
        
        fetchLists()
        fetchSavedLists()
        
    }
    
    func deleteAllCoreData() {
        do {
            try container.persistentStoreCoordinator.destroyPersistentStore(at: container.persistentStoreDescriptions[0].url! , type: NSPersistentStore.StoreType.sqlite) }
        catch {
            print(error)
        }
    }
    
    
    //    maybe fetch in view
    func fetchLists() {
        do {
            usersLists = try container.viewContext.fetch(NSFetchRequest(entityName: "ListEntity"))
        } catch {
            print("failed to fetch lists")
        }
    }
    
    func save() {

        do {
            try container.viewContext.save()
            print("save success ????????????????????????????????")
//            refreshObjects()
            fetchLists()
            
        } catch {
            print(error)
        }

    }
    
    
    func itemExists(itemName: String, itemCategory: String, inPreviewList:Bool = false, listEntity:ListEntity?)->Bool {
        
//        let itemName = item.name
//        let itemCategory = item.category
        
        if inPreviewList {
            
            
            if (previewList[itemCategory]?.filter{$0.itemName == itemName}.count ?? 0 < 1) {
                return false
            } else {
                return true
            }
            
        } else {
            
            let list = listEntity
            let categoryEntities:[CategoryEntity] = list?.category?.allObjects as? [CategoryEntity] ?? []
            
            let categoryFound:Bool = categoryEntities.filter{$0.category == itemCategory}.count > 0
            
            if categoryFound {
                let categoryEntity:CategoryEntity = categoryEntities.filter{$0.category == itemCategory}[0]
                
                let categoryItems = categoryEntity.listItems?.allObjects as? [ListItemEntity]
                
                //                filters to find item
                if categoryItems?.filter{$0.itemName == itemName}.count ?? 0 < 1 {
                    return false
                } else {
                    return true
                }
            } else {
                //                if cat not found that means item doesnt exist
                return false
            }
            
            
        }
    }
    
    func addToList(newItem:ListItem, inPreviewList:Bool = false, listEntity:ListEntity?) {
        
        let itemCategory:String = newItem.category
        
        if inPreviewList {
            if Array(previewList.keys).contains(itemCategory) {
                
                previewList[itemCategory]?.append(newItem)
                
                
            } else {
                previewList[itemCategory] = []
                
                previewList[itemCategory]?.append(newItem)
                
            }
        } else {
            
            let list = listEntity
            let categoryEntities:[CategoryEntity] = list?.category?.allObjects as? [CategoryEntity] ?? []
            
            let categoryFound:Bool = categoryEntities.filter{$0.category == itemCategory}.count > 0
            
            let newListItem:ListItemEntity = ListItemEntity(context: container.viewContext)
            
            newListItem.id = UUID()
            newListItem.date = .now
            newListItem.itemName = newItem.itemName
            newListItem.quantity = newItem.quantity
            newListItem.unit = newItem.unit
            newListItem.isChecked = false
            newListItem.category = newItem.category
            
            
            newListItem.listEntity = list
            
            
            if categoryFound {
                
                let categoryEntity:CategoryEntity = categoryEntities.filter{$0.category == itemCategory}[0]
                
                newListItem.categoryEntity = categoryEntity
                
                categoryEntity.addToListItems(newListItem)
                
            } else {
                
                list?.objectWillChange.send()
                let newCategoryEntity:CategoryEntity = CategoryEntity(context: container.viewContext)
                list?.listName = "test"
                
                
                newCategoryEntity.category = newItem.category
                newCategoryEntity.date = .now
                
                newListItem.categoryEntity = newCategoryEntity
                
                newCategoryEntity.addToListItems(newListItem)
                
//                var testArr:[CategoryEntity] = []
//                
//                testArr = categoryEntities
//                testArr.append(newCategoryEntity)
//                
//                for cat in testArr {
//                    list?.addToCategory(cat)
//                    container.viewContext.refreshAllObjects()
//                }
                list?.addToCategory(newCategoryEntity)
               
//                list.category.
                
//                container.viewContext.refreshAllObjects()
//                save()
            }
                        
                container.viewContext.refreshAllObjects()
                save()

        }
        
    }
    
    
    func refreshObjects() {
        container.viewContext.refreshAllObjects()
    }
    
    
    func calcListQuantity(listEntity:ListEntity) -> Int {
        
        var listCount:Int = 0
        //        var checkedCount:Int = 0
        
        let categories:[CategoryEntity] = listEntity.category?.allObjects as? [CategoryEntity] ?? []
        
        
        for category in categories {
            
            listCount += category.listItems?.count ?? 0
            
            //            var catListItems:[ListItemEntity] = category.listItems?.allObjects as? [ListItemEntity] ?? []
            
            //            checkedCount += catListItems.filter{$0.isChecked == true}.count
            
        }
        
        //        print(listCount)
        
        return listCount
        
    }
    
    func calcItemsChecked(listEntity: ListEntity) -> Double {
        
        var checkedCount:Int = 0
        
        let categories:[CategoryEntity] = listEntity.category?.allObjects as? [CategoryEntity] ?? []
        
        for category in categories {
            
            var catListItems:[ListItemEntity] = category.listItems?.allObjects as? [ListItemEntity] ?? []
            
            checkedCount += catListItems.filter{$0.isChecked == true}.count
            
        }
        //        print(checkedCount)
        return Double(checkedCount)
//        return (Double(calcListQuantity(listEntity: listEntity)) / Double(checkedCount))
        //        return 1
        
    }
    
    func listPercentComplete(userList:ListEntity)->Double {
        
        
        return (calcItemsChecked(listEntity: userList) / Double(calcListQuantity(listEntity: userList))) * 100
        
    }
    
    
    
    func toggleChecked(listId:UUID, item:ListItemEntity) {
        
        item.isChecked.toggle()
        
        save()
        
    }
    
    func fetchSavedLists() {
        
        
        do {
            savedLists = try container.viewContext.fetch(NSFetchRequest(entityName: "SavedListEntity"))
        } catch {
            print("failed to fetch lists")
        }
        
        
    }
    
    func saveList(listEntity:ListEntity) {
        
        let listCategories:[CategoryEntity] = listEntity.category?.allObjects as? [CategoryEntity] ?? []
        
        let savedList:SavedListEntity = SavedListEntity(context: container.viewContext)
        savedList.id = UUID()
        savedList.date = listEntity.date
        savedList.listName = listEntity.listName
        
        for category in listCategories {
            let newSavedCategory:SavedCategoryEntity = SavedCategoryEntity(context: container.viewContext)
            newSavedCategory.category = category.category
            newSavedCategory.date = category.date
            
            let categoryListItems:[ListItemEntity] = category.listItems?.allObjects as? [ListItemEntity] ?? []
            
            savedList.addToSavedCategories(newSavedCategory)
            
            for item in categoryListItems {
                let newSavedItem:SavedListItemEntity = SavedListItemEntity(context: container.viewContext)
                
                newSavedItem.id = UUID()
                newSavedItem.date = item.date
                newSavedItem.itemName = item.itemName
                newSavedItem.category = item.category
                newSavedItem.quantity = item.quantity
                newSavedItem.unit = item.unit
                newSavedItem.isChecked = item.isChecked
                
                
                newSavedCategory.addToSavedItems(newSavedItem)
                
            }
            
            
            container.viewContext.refreshAllObjects()
            save()
            fetchSavedLists()
            
        }
        
    }
    
    func createListFromSaved(listEntity:SavedListEntity) {
        let newList:ListEntity = ListEntity(context: container.viewContext)
        
        
        
        let listCategories:[SavedCategoryEntity] = listEntity.savedCategories?.allObjects as? [SavedCategoryEntity] ?? []
        
        //        let savedList:SavedListEntity = SavedListEntity(context: container.viewContext)
        newList.id = UUID()
        newList.date = .now
        newList.listName = listEntity.listName
        
        for category in listCategories {
            let newCategory:CategoryEntity = CategoryEntity(context: container.viewContext)
            newCategory.category = category.category
            newCategory.date = category.date
            
            let categoryListItems:[SavedListItemEntity] = category.savedItems?.allObjects as? [SavedListItemEntity] ?? []
            
            newList.addToCategory(newCategory)
            
            for item in categoryListItems {
                let newItem:ListItemEntity = ListItemEntity(context: container.viewContext)
                
                newItem.id = UUID()
                newItem.date = item.date
                newItem.itemName = item.itemName
                newItem.category = item.category
                newItem.quantity = item.quantity
                newItem.unit = item.unit
                newItem.isChecked = false
                
                newItem.listEntity = newList
                newItem.categoryEntity = newCategory
                
                newCategory.addToListItems(newItem)
                
            }
            
            
            container.viewContext.refreshAllObjects()
            save()
            
            
        }
        
    }
    
    func updateListName(newListName: String, listEntity: ListEntity) {
        
        listEntity.listName = newListName
        
        container.viewContext.refreshAllObjects()
        save()
        
    }
    
    func createList(listName:String) {
        let newList:ListEntity = ListEntity(context: container.viewContext)
        
        newList.id = UUID()
        newList.date = .now
        newList.listName = listName
        
        //        for every category create a category entity
        //        to set the category value convert value array to nsset categoryentity.listItems as NSSet
        
        //        var testArr:[CategoryEntity] = []
        
        for categoryArr in previewList {
            let newCategory:CategoryEntity = CategoryEntity(context: container.viewContext)
            
            newCategory.category = categoryArr.key
            newCategory.date = .now
            newCategory.list = newList
//            newCategory.addToList(newList)
            newList.addToCategory(newCategory)
            
            
            for item in categoryArr.value {
                let newListItem = ListItemEntity(context: container.viewContext)
                
                newListItem.id = UUID()
                newListItem.date = .now
                newListItem.itemName = item.itemName
                newListItem.quantity = item.quantity
                newListItem.unit = item.unit
                newListItem.isChecked = false
                newListItem.category = item.category
                
                newListItem.listEntity = newList
                newListItem.categoryEntity = newCategory
                
                newCategory.addToListItems(newListItem)
            }
            
            
        }
        
        
        save()
        clearList()
        
    }
    
    func editItem(updatedItem:ListItem, isPreviewList:Bool = false, listId:UUID?, itemEntity:ListItemEntity?) {
        //        item passed in should be the updated item
        var itemName = updatedItem.itemName
        var itemCategory = updatedItem.category
        
        if isPreviewList {
            
            //            get idx instead of getting list item
            var oldItem:ListItem = previewList[itemCategory]?.first(where: {$0.itemName == itemName}) ?? ListItem(itemName: "", quantity: 0.00, unit: "", category: "")
            
            var itemIdx:Int = previewList[itemCategory]?.firstIndex(of: oldItem) ?? 0
            
            previewList[itemCategory]?.remove(at: itemIdx)
            previewList[itemCategory]?.insert(updatedItem, at: itemIdx)
        } else {
            
            itemEntity?.itemName = updatedItem.itemName.isEmpty ? itemEntity?.itemName : updatedItem.itemName
            itemEntity?.date = itemEntity?.date
            itemEntity?.quantity = updatedItem.quantity
            itemEntity?.unit = updatedItem.unit
            
            
            container.viewContext.refreshAllObjects()
            save()
            
        }
        
    }
    
    
    func deleteItem(item: ListItem, isPreviewList:Bool = false, listId:UUID?) {
        var itemName = item.itemName
        var itemCategory:String = item.category
        
        if isPreviewList {
            previewList[itemCategory] = previewList[itemCategory]?.filter{$0.itemName != itemName}
            
            if previewList[itemCategory]?.count ?? 0 < 1 {
                previewList.removeValue(forKey: itemCategory)
            }
        } else {
            //            print(item)
            var listIdx = usersLists.firstIndex(where: {$0.id == listId}) ?? 0
            //            var list = usersLists[listIdx].listItems
            //            var categoryArr = list?[itemCategory]
            //            print(categoryArr)
            //            var itemIdx = list?[itemCategory]?.firstIndex(where: {$0.itemName == itemName}) ?? 0
            
            //            usersLists[listIdx].listItems?[itemCategory]?.remove(at: itemIdx)
        }
        
        
    }
    
    
    func deleteItemUserList(item:ListItemEntity) {
        
        
        container.viewContext.delete(item)
        
        
        if item.categoryEntity?.listItems?.count == 1 {
            container.viewContext.delete(item.categoryEntity ?? CategoryEntity())
        }
        
        container.viewContext.refreshAllObjects()
        save()
        
    }
    
    func deleteList(listEntity:ListEntity) {
        
        container.viewContext.delete(listEntity)
        
        
        container.viewContext.refreshAllObjects()
        save()
        
    }
    
    func deleteSavedList(savedListEntity:SavedListEntity) {
        
        container.viewContext.delete(savedListEntity)
        container.viewContext.refreshAllObjects()
        save()
        fetchSavedLists()
        
    }
    
    func clearList() {
        previewList = [:]
    }
    
}

