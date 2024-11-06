//
//  CategoryView.swift
//  GroceryListAppNew
//
//  Created by Joshua Hankins on 7/23/24.
//

import SwiftUI


struct CategoryView: View {
    
    @EnvironmentObject var groceryVM:GroceryViewModel
    
    var category:String
    var categoryArr:[GroceryItemStruct]
    
    //    @State var addItemFormOpen:Bool = false
    
    //    @State var selectedItem:AddItemStruct?
    @State var selectedItem:GroceryItemStruct?
    
    @State var searchText:String = ""
    
    @State var searchActive:Bool = false
    
    var inPreviewList = false
    
    var listEntity:ListEntity?
    
    @State var defaultItems:String = "basic"
    
    var body: some View {
        //        NavigationStack {
        ZStack {
            Color("Gray_Main").ignoresSafeArea()
            
            VStack(spacing: 0) {
                Text("")
                    .searchable(text: $searchText, isPresented: $searchActive)
                    .foregroundStyle(Color("Font_Dark"))
                
                HStack(alignment: .top) {
                    
                    TabButton(tabText: "Basic Items", defaultItems: $defaultItems, tabValue: "basic")
                    
                    Spacer()
                    
                    TabButton(tabText: "Custom Items", defaultItems: $defaultItems, tabValue: "custom")
                    
                    
                }
                .padding([.leading, .trailing], 20)
//                .padding([.top, .bottom])
//                .border(.blue)
                
                if defaultItems == "basic" {
                    List(filteredItems, id: \.self) { item in
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
                        
                    }
                    .scrollContentBackground(.hidden)
                    .listStyle(.insetGrouped)
                    .sheet(item: $selectedItem) { item in
                        AddItemForm(item: item, category:category, inPreviewList: inPreviewList, listEntity: listEntity)
                    }
                } else {
                    CustomItems(category:category, selectedItem: $selectedItem, searchText: $searchText)
                        .sheet(item: $selectedItem) { item in
                            AddItemForm(item: item, category:category, inPreviewList: inPreviewList, listEntity: listEntity)
                        }
                    
                    
                }
                
                
                Spacer()
            }
            
            
            
        }
        .navigationTitle(category)
        //        }
    }
    
    //    return tuple maybe with regular items and custom items
    var filteredItems: [GroceryItemStruct] {
        
        if searchText.isEmpty {
            return categoryArr
        } else {
            return categoryArr.filter{$0.name.contains(searchText)}
        }
        
    }
}


struct AddItemForm: View {
    
    @EnvironmentObject var userListsVM:UserListsViewModel
    @EnvironmentObject var groceryVM:GroceryViewModel
    
    var item:GroceryItemStruct
    var category:String
    
    
    //    have different unit options for different items
    //    @State var unitOptions:[String] = []
    
    @State var itemName:String = ""
    
    @State var quantity:Double = 0.00
    @State var unitSelection:String = "x"
    @State var itemNotes:String = ""
    
    @State var isChecked:Bool = false
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State var searchText:String = ""
    
    @State var addItemAlertOpen:Bool = false
    @State var customItemAlertOpen:Bool = false
    
    var inPreviewList = false
    
    var listEntity:ListEntity?
    
    @State var placeholder:String = ""
    
    @State var updateNameChecked:Bool = false
    
    
    let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.zeroSymbol = ""
        return formatter
    }()
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("Gray_Main").ignoresSafeArea()
                
                VStack {
                    
                    VStack (alignment: .trailing, spacing: 50) {
                        
                        if !item.isCustomItem {
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
                        }
                        
                        HStack {
                            Section {
                                TextField("", value: $quantity, formatter: formatter)
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

                        if !item.isCustomItem {
                            HStack (spacing: 8) {
                                if isChecked {
                                    Image(systemName: "checkmark.square.fill")
                                        .font(.system(size: 32))
                                        .foregroundStyle(Color("Purple_Main"))
                                } else {
                                    Image(systemName: "square")
                                        .font(.system(size: 32))
                                        .foregroundStyle(Color("Gray_Light"))
                                }
                                
                                
                                Text("Save as custom item?")
                                    .foregroundStyle(Color("Font_Darker"))
                                
                            }
                            .onTapGesture {
                                isChecked.toggle()
                            }
                        }
                        
                        
                    }
                    
                    Spacer()
                    
                    Button {
                        
                        if quantity > 0.00 {
                            
                            if inPreviewList {
                                
                                if !userListsVM.itemExists(itemName: itemName.isEmpty ? item.name : itemName, itemCategory: item.category,inPreviewList: true, listEntity: nil) {
                                    
                                    
                                    if isChecked {
                                        if !groceryVM.itemExists(itemName: itemName.isEmpty ? item.name : itemName) {
                                            groceryVM.createCustomItem(item: GroceryItemStruct(name: itemName.isEmpty ? item.name : itemName, category: item.category))
                                            userListsVM.addToList(newItem: ListItem(itemName: itemName.isEmpty ? item.name : itemName, quantity: quantity, unit: unitSelection, category: item.category), inPreviewList:true, listEntity: nil)
                                            self.presentationMode.wrappedValue.dismiss()
                                        } else {
                                            customItemAlertOpen = true
                                        }
                                        
                                    } else {
                                        userListsVM.addToList(newItem:ListItem(itemName: itemName.isEmpty ? item.name : itemName, quantity: quantity, unit: unitSelection, category: item.category), inPreviewList: true,listEntity: nil)
                                        self.presentationMode.wrappedValue.dismiss()
                                    }
                                    
                                    
                                    
                                } else {
                                    addItemAlertOpen = true
                                }
                                
                            } else {
                                
                                if !userListsVM.itemExists(itemName: itemName.isEmpty ? item.name : itemName, itemCategory: item.category, listEntity: listEntity) {
                                    
                                    
                                    
                                    if isChecked {
                                        if !groceryVM.itemExists(itemName: itemName.isEmpty ? item.name : itemName) {
                                            groceryVM.createCustomItem(item: GroceryItemStruct(name: itemName.isEmpty ? item.name : itemName, category: item.category))
                                            userListsVM.addToList(newItem:ListItem(itemName: itemName.isEmpty ? item.name : itemName, quantity: quantity, unit: unitSelection, category: item.category), listEntity: listEntity)
                                            self.presentationMode.wrappedValue.dismiss()
                                        } else {
                                            customItemAlertOpen = true
                                        }
                                        
                                    } else {
                                        userListsVM.addToList(newItem:ListItem(itemName: itemName.isEmpty ? item.name : itemName, quantity: quantity, unit: unitSelection, category: item.category), listEntity: listEntity)
                                        self.presentationMode.wrappedValue.dismiss()
                                    }
                                    
                                    
                                } else {
                                    addItemAlertOpen = true
                                }
                                
                            }
                            
                            
                            
                        }
                        
                    } label: {
                        MainButton(text: "Add to List")
                    }
                    
                    
                }
                .padding()
                .alert("This item is already in your list", isPresented: $addItemAlertOpen) {
                    Button("Close", role: .cancel) {
                        addItemAlertOpen = false
                    }
                }
                .alert("This is already a custom item", isPresented: $customItemAlertOpen) {
                    Button("Close", role: .cancel) {
                        customItemAlertOpen = false
                    }
                }
                .toolbar {
                    ToolbarItem {
                        Button("Cancel") {
                            self.presentationMode.wrappedValue.dismiss()
                        }
                    }
                }
                .onAppear() {
                    //                    itemName = item.name
                }
                
            }
            .navigationTitle("\(item.name)")
        }
        
    }
}



struct TabButton: View {
    
    var tabText:String
    @Binding var defaultItems:String
    var tabValue:String
    
    var body: some View {
        
            
            HStack {
                VStack(spacing: 5) {
                    Text(tabText)
                        .foregroundStyle(defaultItems == tabValue ? Color("Font_Secondary") : Color("Font_Darker"))
                    
                    if defaultItems == tabValue {
                        RoundedRectangle(cornerRadius: 10)
                            .frame(height: 3)
                            .frame(width: 45)
                            .foregroundStyle(Color("Purple_Main"))
                    }
                    
                    
                }
            }
            .onTapGesture {
                defaultItems = tabValue
            }
            .frame(maxWidth: .infinity)
            .padding([.top, .bottom])
            
    }
}
