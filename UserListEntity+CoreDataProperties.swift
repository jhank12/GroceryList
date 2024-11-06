//
//  UserListEntity+CoreDataProperties.swift
//  GroceryListAppNew
//
//  Created by Joshua Hankins on 8/2/24.
//
//

import Foundation
import CoreData


extension UserListEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserListEntity> {
        return NSFetchRequest<UserListEntity>(entityName: "UserListEntity")
    }

    @NSManaged public var date: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var listName: String?
    @NSManaged public var categoryEntity: NSSet?

}

// MARK: Generated accessors for categoryEntity
extension UserListEntity {

    @objc(addCategoryEntityObject:)
    @NSManaged public func addToCategoryEntity(_ value: CategoryEntity)

    @objc(removeCategoryEntityObject:)
    @NSManaged public func removeFromCategoryEntity(_ value: CategoryEntity)

    @objc(addCategoryEntity:)
    @NSManaged public func addToCategoryEntity(_ values: NSSet)

    @objc(removeCategoryEntity:)
    @NSManaged public func removeFromCategoryEntity(_ values: NSSet)

}

extension UserListEntity : Identifiable {

}
