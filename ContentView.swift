//
//  ContentView.swift
//  ToDoListExample
//
//  Created by Panagiotis Kapsalis Skoufos on 11/4/20.
//  Copyright © 2020 Panagiotis Kapsalis Skoufos. All rights reserved.
//

import SwiftUI

let white:Color = Color(red:224/255,green:224/255,blue:224/255)
let black:Color = Color(red:32/255,green:32/255,blue:32/255)

struct ContentView: View {
    var body: some View {
        ItemsView()
    }
}

struct ItemsView:View
{
    @State var edit:Bool = false
    var body:some View
    {
        VStack
        {
            ItemsHeaderView(edit:$edit)
            ItemsBodyView(edit:$edit)
            Spacer()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct ItemsBodyView:View
{
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(
        entity: Item.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \Item.itemDescription, ascending: true)
        ]
    ) var items: FetchedResults<Item>
    
    @Binding var edit:Bool
    
    var body:some View
    {
        VStack
        {
            
                List
                {
                    ForEach(items)
                    {
                        i in
                        
                            HStack{
                                Text(i.itemDescription)
                                Spacer()
                                if i.checked
                                {
                                    Image(systemName:"checkmark")
                                        .font(Font.title.weight(.bold))
                                        .foregroundColor(black)
                                }
                                if self.edit
                                {
                                    Image(systemName:"trash")
                                        .font(Font.title.weight(.bold))
                                        .foregroundColor(black)
                                        .onTapGesture()
                                        {
                                            self.delete(i)
                                        }
                                }
                            }.padding()
                                .foregroundColor(black)
                                .background(white)
                            .cornerRadius(20)
                            .onTapGesture (count: 2){
                                i.checked.toggle()
                                
                                do {
                                   try self.managedObjectContext.save()
                                } catch {
                                  print(error)
                                    }
                            
                        }
                    }
                
            }
        }
    }
    func delete(_ i:Item)
    {
        managedObjectContext.delete(i)
       
        do {
           try self.managedObjectContext.save()
        } catch {
          print(error)
            }
    }
}


struct ItemsHeaderView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @State var str:String = ""
    @Binding var edit:Bool
    var body: some View {
        VStack{
            
            
            HStack{
                Spacer()
                Text("List")
                    .bold()
                    .font(.title)
                Spacer()
                Button(action:{
                   self.edit.toggle()
               })
               {
                    Text("Edit")
                    .font(.body)
                    .bold()
                    .padding(5)
                    .foregroundColor(black)
                    .background(white)
                    .cornerRadius(10)
                    .overlay(
                    RoundedRectangle(cornerRadius: 10)
                    .stroke(black,lineWidth: 2))
                }
            }
            HStack{
                Spacer()
                TextField("Item",text: $str)
                .padding(10)
                .foregroundColor(white)
                .background(black)
                    .cornerRadius(20)
                Spacer()
                Button(action:
                {
                    self.insert()
                })
                {
                    Image(systemName:"plus")
                        .font(Font.title.weight(.bold))
                    .foregroundColor(black)
                    
                }
                
            }
            
            
        }.padding()
            .background(white)
    }
    func insert()
    {
        if self.str.trimmingCharacters(in: [" "]) != ""
        {
            let i = Item(context: self.managedObjectContext)
            i.itemID = UUID()
            i.itemDescription = self.str
            i.checked = false
            do {
               try self.managedObjectContext.save()
            } catch {print("error insering list")}
            self.str = ""
        }
    }
}
