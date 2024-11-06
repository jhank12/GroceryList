//
//  CustomItemsView.swift
//  GroceryListAppNew
//
//  Created by Joshua Hankins on 8/15/24.
//

import SwiftUI


struct CustomItems: View {
    
    @EnvironmentObject var groceryVM:GroceryViewModel
    
    var category:String
    
    //    for add item form
    @Binding var selectedItem:GroceryItemStruct?
    
    //    for edit item form
    @State var selectedCustomItem:GroceryItemStruct?
    
    @Binding var searchText:String
    
    
    var body: some View {
        
        if !filteredItems.isEmpty {
            List(filteredItems) { item in
               
                    HStack {
                        
                        Text("\(item.name)")
                        
                        Spacer()
                        
                        Button {
                            selectedItem = item
                        } label: {
                            Image(systemName: "plus")
                        }
                        
                    }
                    .padding([.top, .bottom])
                    .padding([.leading, .trailing], 5)
                    .foregroundStyle(Color("Font_Dark"))
                    .listRowBackground(Color("Gray_Secondary"))
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        Button(action: {
                            groceryVM.deleteCustomItem(customItemName: item.name)
                            
                        }, label: {
                            Image(systemName: "trash.fill")
                        })
                        .tint(.red)
                        
                        
                        Button (action: {
                            
                            selectedCustomItem = item
                            
                        }, label: {
                            Image(systemName: "square.and.pencil")
                                .font(.system(size: 72))
                        })
                        .tint(.yellow)
                    }
               

            }
            .scrollContentBackground(.hidden)
            .listStyle(.insetGrouped)
            .sheet(item: $selectedCustomItem) { item in
                
                CustomItemEditSheet(item:item)
                
            }
        } else {
            
            Spacer()
            Text("You don't have any custom items")
                .foregroundStyle(Color("Font_Darker"))
                .font(.system(size: 16))
                .fontWeight(.medium)
            
            Spacer()
        }
            
            
        
    }
    
    var filteredItems: [GroceryItemStruct] {
        
        if searchText.isEmpty {
            return groceryVM.customItems[category] ?? []
        } else {
            return groceryVM.customItems[category]?.filter{$0.name.contains(searchText)} ?? []
        }
        
    }
}

struct CustomItemEditSheet: View {
    
    @EnvironmentObject var groceryVM:GroceryViewModel
    
    var item:GroceryItemStruct
    
    @State var updatedName:String = ""
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("Gray_Main").ignoresSafeArea()
                
                VStack {
                    HStack {
                        Section {
                            TextField("", text: $updatedName)
                                .padding()
                                .foregroundStyle(Color("Font_Dark"))
                                .background(Color("Gray_Secondary"))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .keyboardType(.decimalPad)
                            
                            
                        } header: {
                            HStack {
                                Text("Updated Name")
                                    .foregroundStyle(Color("Font_Darker"))
                                Spacer()
                            }
                        }
                    }
                    
                    Spacer()
                    
                    if !updatedName.isEmpty && updatedName != item.name {
                        Button {
                            
                            //                            groceryVM.editCustomItem(updatedItemName: updatedName, oldItemName: item.name)
                            groceryVM.editCustomItem(updatedItemName: updatedName, oldItemName: item.name)
                            
                        } label: {
                            MainButton(text: "Update Item")
                        }
                    }
                    
                    
                    
                    
                }
                .padding()
                .toolbar {
                    ToolbarItem {
                        Button("Cancel") {
                            self.presentationMode.wrappedValue.dismiss()
                        }
                    }
                }
                
            }
            .navigationTitle("Edit Custom Item")
        }
        .onAppear() {
            updatedName = item.name
        }
    }
}
