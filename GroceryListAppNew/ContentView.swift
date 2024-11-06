//
//  ContentView.swift
//  GroceryListAppNew
//
//  Created by Joshua Hankins on 7/22/24.
//

import SwiftUI


struct ContentView: View {
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(Color("Font_Main"))]
    }
    
    @EnvironmentObject var userListsVM:UserListsViewModel
    
    //    @State var path = NavigationPath()
    
    @EnvironmentObject var router:Router
    
    @State var newListOptionsOpen:Bool = false
    
    
    @State var iconTest:Bool = false
    
    
    var body: some View {
        
        NavigationStack(path: $router.path) {
            ZStack {
                Color("Gray_Main").ignoresSafeArea()
                
                VStack {
                    ScrollView {
                        
                        Spacer().frame(height: 30)
                        
                        VStack (alignment: .leading,  spacing: 35) {
                            
                            VStack (spacing: 0) {
                                ForEach(userListsVM.usersLists.sorted{$0.date ?? .now > $1.date ?? .now}, id: \.self) { userList in
                                    VStack (alignment: .leading, spacing: 8) {
                                        
                                        Text(userList.date ?? .now, format: .dateTime.day().month(.wide).year())
                                            .fontWeight(.medium)
                                            .font(.system(size: 22))
                                            .foregroundStyle(Color("Font_Secondary"))
                                        
                                        NavigationLink (value:userList) {
                                            UserListLink(userList:userList)
                                        }
                                        
                                        Spacer().frame(height:35)
                                    }
                                    
                                    
                                }
                                .navigationDestination(for: ListEntity.self) { userList in
                                    
                                    ListView(userListId: userList.id ?? UUID(),
                                             userList:userList)
                                    
                                }
                                .navigationDestination(isPresented: $newListOptionsOpen) {
                                    NewListOptionsView(newListOptionsBool:$newListOptionsOpen)
                                }
                                
                            }
                        }
                        .frame(maxWidth: .infinity)
                        
                    }
                    
                    
                    Spacer()

                    
                    VStack {
                      
                            Button {
                                newListOptionsOpen = true
                            } label: {
                                
                                VStack {
                                    ZStack {
                                        
                                        
//                                        Circle()
//                                            .frame(width:80)
//                                            .foregroundStyle(Color("Gray_Secondary"))
                                        
                                        Circle()
                                            .frame(width: 70)
                                            .foregroundStyle(Color("Purple_Main"))
                                        
                                        Image(systemName: "plus")
                                            .font(.system(size: 25))
                                            .foregroundStyle(Color("Font_Main"))
                                        
                                        
                                    }
                                    
//                                            Spacer().frame(height: 30)
                                }
//                                        .padding([.bottom], 20)
                               
                            }

                    }

                }
                .padding()
                
                
            }
            .navigationTitle("Home")
            
        }
        
    }
}

#Preview {
    
    ContentView()
        .environmentObject(UserListsViewModel())
        .environmentObject(GroceryViewModel())
        .environmentObject(Router())
    
}

struct UserListLink: View {
    
    @EnvironmentObject var userListsVM:UserListsViewModel
    
    @ObservedObject var userList:ListEntity
    
    var body: some View {
        HStack {
            
            VStack {
                HStack {
                    
                    VStack (alignment: .leading, spacing: 2)  {
                        Text("\(userList.listName ?? "")")
                            .foregroundStyle(Color("Font_Secondary"))
                            .font(.system(size: 18))
                        
                        Text("Items: \(userListsVM.calcListQuantity(listEntity: userList))")
                            .font(.system(size: 16))
                            .foregroundStyle(Color("Font_Darker"))
                    }
                    
                    Spacer()
                    
                    
                    Text("\(userListsVM.listPercentComplete(userList:userList), specifier: "%.0f")% complete")
                        .foregroundStyle(Color("Font_Darker"))
                        .font(.system(size: 16))
                    
                }
                .fontWeight(.medium)
                
                ProgressView("", value: userListsVM.listPercentComplete(userList:userList) / 100, total: 1.00)
                    .tint(Color("Purple_Main"))
                    .scaleEffect(x:1 , y:0.75)
            }
            
        }
        .frame(maxWidth: .infinity)
        .padding(24)
        .foregroundStyle(Color("Font_Secondary"))
        .background(Color("Gray_Secondary"))
        .clipShape(RoundedRectangle(cornerRadius: 25))
    }
}


