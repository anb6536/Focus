//
//  ToDoView.swift
//  Focus
//
//  Created by Aahish Balimane on 4/5/22.
//

import SwiftUI

struct ToDoView: View {
    
    @Environment(\.managedObjectContext) var context
    
    @FetchRequest(entity: ToDoItem.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \ToDoItem.priorityNum, ascending: false)])
    
    var toDoList: FetchedResults<ToDoItem>

    @State private var showNewTask = false
    
    var body: some View {
        Color(red: 70/255, green: 70/255, blue: 70/255)
            .edgesIgnoringSafeArea(.all)
            .overlay(
                ZStack {
                    VStack {
                        HStack {
                            Text("Focus")
                                .foregroundColor(.white)
                                .font(.system(.title, design: .rounded))
                            .fontWeight(.semibold)
                            .padding()
                            
                            Spacer()
                        }
                        
                        VStack {
                            VStack {
                                List {
                                    ForEach (toDoList) {
                                        item in

                                        if(!item.isComplete) {
                                            ToDoRowView(item: item)
                                        }
                                    }

                                    ForEach(toDoList) {
                                        item in

                                        if(item.isComplete) {
                                            ToDoRowView(item: item)
                                        }
                                    }
                                }
                                .frame(maxHeight: 560)
                                
                                Button {
                                    showNewTask.toggle()
                                } label: {
                                    HStack {
                                        Image(systemName: "plus")
                                        Text("New Item")
                                    }
                                }
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity, maxHeight: 60)
                                .background(.white)
                                .cornerRadius(20)
                                .padding(.horizontal)
                                .padding(.bottom)
                                
                                Spacer()
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color(red: 235/255, green: 235/255, blue: 235/255))
                        .cornerRadius(50, corners: [.topLeft, .topRight])
                        .offset(x: 0, y: 10)
                    }
                    .rotation3DEffect(Angle(degrees: showNewTask ? 5 : 0), axis: (x: 1, y: 0, z: 0))
                    .offset(y: showNewTask ? -50 : 0)
                    .animation(.easeOut)
                    
                    if showNewTask {
                        BlankView(bgColor: .black)
                            .opacity(0.5)
                            .onTapGesture {
                                self.showNewTask = false
                            }
                        
                        NewToDoView(isShow: $showNewTask, name: "", priority: .normal, dateDue: Date(), dateReminder: Date())
                            .transition(.move(edge: .bottom))
                            .animation(.interpolatingSpring(stiffness: 200.0, damping: 25.0, initialVelocity: 10.0))
                    }
                }
            )
    }
}

struct BlankView : View {

    var bgColor: Color

    var body: some View {
        VStack {
            Spacer()
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .background(bgColor)
        .edgesIgnoringSafeArea(.all)
    }
}

struct ToDoRowView: View {
    @Environment(\.managedObjectContext) var context
    @ObservedObject var item: ToDoItem
    
    var body: some View {
        Toggle(isOn: self.$item.isComplete) {
            HStack {
                VStack {
                    HStack {
                        Text("\(self.item.content)")
                            .font(.system(.title2, design: .rounded))
                            .fontWeight(.bold)
                            .strikethrough(self.item.isComplete, color: .black)
                        Spacer()
                    }
                    HStack {
                        HStack {
                            if self.item.dateRemind != nil {
                                Image(systemName: "bell")
                                Text("\(self.item.dateRemind != nil  ? getDateString(date: self.item.dateRemind!) : "")")
                            }
                        }
                        
                        HStack {
                            if self.item.dateDue != nil {
                                Image(systemName: "clock")
                                Text("\(self.item.dateDue != nil  ? getDateString(date: self.item.dateDue!) : "")")
                            }
                        }
                        Spacer()
                    }
                }
                
                Spacer()
                
                if self.item.priority == Priority.normal {
                    Text("🟡")
                } else if self.item.priority == Priority.high {
                    Text("🔴")
                } else {
                    Text("🟢")
                }
            }
            .padding(.leading, 10)
            .onTapGesture {
                item.isComplete.toggle()
                do {
                    try context.save()
                } catch {
                    print(error)
                }
            }
        }
        .toggleStyle(CheckboxStyle())
        .onReceive(item.objectWillChange) { _ in
            if self.context.hasChanges {
                try? self.context.save()
            }
        }
    }
}

extension ToDoRowView {
    func getDateString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d"
        return dateFormatter.string(from: date)
    }
}

struct ToDoView_Previews: PreviewProvider {
    static var previews: some View {
        ToDoView()
    }
}
