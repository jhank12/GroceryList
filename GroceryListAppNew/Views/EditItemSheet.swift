//
//  EditItemSheet.swift
//  GroceryListAppNew
//
//  Created by Joshua Hankins on 8/5/24.
//

import SwiftUI

struct EditItemSheet: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var userListsVM:UserListsViewModel
    
    @EnvironmentObject var groceryVM:GroceryViewModel
    
    var item:ListItem
    var isPreviewList:Bool = false
    
    var itemEntity:ListItemEntity?
    
    @State var itemName:String = ""
    @State var quantity:Double = 0.00
    @State var unitSelection:String = ""
    @State var itemNotes:String = ""
    
    var userListId: UUID?
    
    var unitOptions:[String] = ["x", "lb", "oz"]
    
    var body: some View {
        
        NavigationStack {
            ZStack {
                Color("Gray_Main").ignoresSafeArea()
                
                VStack {
                    VStack (alignment: .trailing, spacing: 50) {
                        
                        HStack {
                            Section {
                                TextField("", text: $itemName)
                                    .padding()
                                    .foregroundStyle(Color("Font_Dark"))
                                    .background(Color("Gray_Secondary"))
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .keyboardType(.default)
                                
                                
                            } header: {
                                HStack {
                                    Text("Item Name")
                                        .foregroundStyle(Color("Font_Darker"))
                                    Spacer()
                                }
                            }
                        }
                        
                        HStack {
                            Section {
                                TextField("Quantity", value: $quantity, format: .number)
                                    .padding()
                                    .foregroundStyle(Color("Font_Dark"))
                                    .background(Color("Gray_Secondary"))
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .keyboardType(.decimalPad)
                                
                                
                            } header: {
                                HStack {
                                    Text("Quantity")
                                        .foregroundStyle(Color("Font_Darker"))
                                    Spacer()
                                }
                            }
                        }
                        
                        HStack {
                            Section {
                                Picker("Unit", selection: $unitSelection) {
                                    ForEach(item.category == "Drinks" ?  groceryVM.liquidUnitsArr : groceryVM.regularUnitsArr, id: \.self) {
                                        Text($0)
                                        
                                    }
                                    
                                }
                                .pickerStyle(.menu)
                                .tint(Color("Purple_Main"))
                            } header: {
                                HStack {
                                    
                                    Text("Unit")
                                        .foregroundStyle(Color("Font_Darker"))
                                    Spacer()
                                }
                            }
                        }
                        
                        
                    }
                    
                    Spacer()
                    
                    if  !itemName.isEmpty || quantity != item.quantity || unitSelection != item.unit  {
                        Button {
                            
                            if isPreviewList {
                                userListsVM.editItem(updatedItem: ListItem(itemName: itemName.isEmpty ? item.itemName : itemName, quantity: quantity, unit: unitSelection, category: item.category), isPreviewList: true, listId: nil, itemEntity: nil)
                            } else {
                                userListsVM.editItem(updatedItem: ListItem(itemName: itemName, quantity: quantity, unit: unitSelection, category: item.category), listId: userListId, itemEntity: itemEntity)
                            }

                            dismiss()
                            
                        } label: {
                            MainButton(text: "Update Item")
                        }
                    }
                    
                }
                .padding()
                .toolbar {
                    ToolbarItem {
                        Button("Cancel") {
                            dismiss()
                        }
                    }
                }
                
            }
            .navigationTitle(item.itemName)
            .onAppear() {
                quantity = item.quantity
                unitSelection = item.unit
                
            }
        }
    }
    
}


