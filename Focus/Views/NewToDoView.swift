
import SwiftUI

struct NewToDoView: View {
    
    @Environment(\.managedObjectContext) var context
    
    @Binding var isShow: Bool
    
    @State var name: String
    @State var priority: Priority
    @State var isEditing = false
    
    @State var dateDue: Date
    @State var dueDateSelect = false
    
    @State var dateReminder: Date
    @State var reminderDateSelected = false
    
    var body: some View {
        VStack {
            Spacer()
            
            VStack(alignment: .leading) {
                HStack {
                    Text("Add a new To-Do")
                        .font(.system(.title, design: .rounded))
                        .bold()
                    
                    Spacer()
                    
                    Button(action: {
                        
                        if self.name.trimmingCharacters(in: .whitespaces) == "" {
                            return
                        }
                        
                        self.isShow = false
                        self.addTask(content: name, priority: priority, isComplete: false, dateDue: dueDateSelect ? dateDue : nil, dateRemind: reminderDateSelected ? dateReminder : nil)
                        
                    }) {
                        Text("Save")
                            .font(.system(.headline, design: .rounded))
                            .frame(minWidth: 0, maxWidth: 50)
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.blue)
                            .cornerRadius(20)
                    }
                    
                    Button(action: {
                        self.isShow = false
                        
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.black)
                            .font(.headline)
                    }
                }
                
                TextField("Enter the task description", text: $name, onEditingChanged: { (editingChanged) in
                    
                    self.isEditing = editingChanged
                    
                })
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .padding(.bottom)
                
                Text("Priority")
                    .font(.system(.subheadline, design: .rounded))
                    .padding(.bottom)
                
                HStack {
                    Text("High")
                        .font(.system(.headline, design: .rounded))
                        .padding(10)
                        .background(priority == .high ? Color.red : Color(.systemGray4))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .onTapGesture {
                            self.priority = .high
                        }
                    
                    Text("Normal")
                        .font(.system(.headline, design: .rounded))
                        .padding(10)
                        .background(priority == .normal ? Color.orange : Color(.systemGray4))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .onTapGesture {
                            self.priority = .normal
                        }
                    
                    Text("Low")
                        .font(.system(.headline, design: .rounded))
                        .padding(10)
                        .background(priority == .low ? Color.green : Color(.systemGray4))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .onTapGesture {
                            self.priority = .low
                        }
                }
                .padding(.bottom, 30)
                
                //MARK: TODO Add Reminder Date Selector
                if reminderDateSelected {
                    DatePicker("Reminder", selection: $dateReminder, displayedComponents: [.date])
                        .frame(maxWidth: .infinity, maxHeight: 60)
                } else {
                    Button {
                        reminderDateSelected.toggle()
                    } label: {
                        HStack {
                            Image(systemName: "plus")
                            Text("Add Reminder Date")
                        }
                    }
                    .buttonStyle(.bordered)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity, maxHeight: 60)
                    .tint(.blue)
                    .padding(.horizontal)
                }
                //MARK: TODO Add Due Date Selector
                if dueDateSelect {
                    DatePicker("Due Date", selection: $dateDue, displayedComponents: [.date])
                        .padding(.vertical, 10)
                        .frame(maxWidth: .infinity, maxHeight: 60)
                } else {
                    Button {
                        dueDateSelect.toggle()
                    } label: {
                        HStack {
                            Image(systemName: "plus")
                            Text("Add Due Date")
                        }
                    }
                    .buttonStyle(.bordered)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity, maxHeight: 60)
                    .tint(.blue)
                    .padding(.horizontal)
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(10, antialiased: true)
            .offset(y: isEditing ? -320 : -70)
        }
        .edgesIgnoringSafeArea(.bottom)
    }
    
    private func addTask(content: String, priority: Priority, isComplete: Bool = false, dateDue: Date?, dateRemind: Date? ) {
        
        let task = ToDoItem(context: context)
        task.id = UUID()
        task.content = content
        task.priority = priority
        task.isComplete = isComplete
        task.dateDue = dateDue
        task.dateRemind = dateRemind
        
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
}


struct NewToDoView_Previews: PreviewProvider {
    static var previews: some View {
        NewToDoView(isShow: .constant(true), name: "", priority: .normal, dateDue: Date(), dateReminder: Date())
    }
}


