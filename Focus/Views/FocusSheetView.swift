//
//  FocusSheetView.swift
//  Focus
//
//  Created by Aahish Balimane on 4/8/22.
//

import SwiftUI

struct FocusSheetView: View {
    
    @Environment(\.managedObjectContext) var context
    
    @FetchRequest(entity: ToDoItem.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \ToDoItem.priorityNum, ascending: false)])
    
    var toDoList: FetchedResults<ToDoItem>

//    @Binding var todoList: [ToDoModel]
    @Binding var selectedTask: ToDoItem?
    @Binding var isButtonPressed: Bool
    @Binding var isFocusMode: Bool
    
    var body: some View {
        List {
            ForEach (toDoList) {
                item in
                
                ToDoRowSheetView(item: item)
                    .onTapGesture {
                        selectedTask = item
                        isButtonPressed = false
                        isFocusMode.toggle()
                    }
            }
        }
    }
}

struct ToDoRowSheetView: View {
    @ObservedObject var item: ToDoItem
    
    var body: some View {
//        Toggle(isOn: self.$item.isComplete) {
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
//        }
//        .toggleStyle(CheckboxStyle())
    }
}

extension ToDoRowSheetView {
    func getDateString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d"
        return dateFormatter.string(from: date)
    }
}

struct FocusSheetView_Previews: PreviewProvider {
    static var previews: some View {
        FocusSheetView(selectedTask: .constant(nil), isButtonPressed: .constant(true), isFocusMode: .constant(false))
    }
}
