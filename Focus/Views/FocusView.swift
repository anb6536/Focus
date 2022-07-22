//
//  FocusView.swift
//  Focus
//
//  Created by Aahish Balimane on 4/4/22.
//

import SwiftUI

struct FocusView: View {
    
    @Environment(\.managedObjectContext) var context
    
    @FetchRequest(entity: ToDoItem.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \ToDoItem.priorityNum, ascending: false)])
    
    var toDoList: FetchedResults<ToDoItem>

    
    @State var focusTime = Date.now
    @State var duration: Double = 60
    @State var isFocusMode = false
    @State var buttonClicked = false
    @State var selectedTask: ToDoItem?
    @ObservedObject var timerClass: TimerClass
    @State var isShowAlert: Bool = false
    
    var body: some View {
        Color(red: 70/255, green: 70/255, blue: 70/255)
            .edgesIgnoringSafeArea(.all)
            .overlay(
                VStack {
                    HStack {
                        Text("Focus")
                            .foregroundColor(.white)
                            .font(.system(.title, design: .rounded))
                        .fontWeight(.semibold)
                        .padding()
                        
                        Spacer()
                    }
                    
                    HStack {
                        Text("Focus Hours: \(getFocusHours() <= 60.0 ? String(format: "%.0f", getFocusHours()) : String(format: "%.1f", getFocusHours())) \(getFocusHours() <= 60.0 ? "Mins" : "Hrs")")
                            .foregroundColor(.white)
                            .font(.system(.title, design: .rounded))
                            .padding()
                            .padding(.bottom, -10)
                        
                        Spacer()
                    }
                    
                    HStack {
                        Text("Tasks Finished: \(getTasksFinished())")
                            .foregroundColor(.white)
                            .font(.system(.title, design: .rounded))
                            .padding(.horizontal)
                            .padding(.top, -10)
                        
                        Spacer()
                    }
                                        
                    VStack {
                        
                        VStack {
                            ZStack {
                                DateView(duration: $duration)
                                    .padding(.vertical, 50)
                                    .opacity(isFocusMode ? 0 : 1)
                                
                                VStack {
                                    TimerView(seconds: $duration, isFocusMode: isFocusMode, alertShown: $isShowAlert)
                                        .font(.title)
                                    
                                    VStack {
                                        Text("Selected Task:")
                                            .font(.system(.title3, design: .rounded))
                                            .fontWeight(.bold)
                                            .foregroundColor(.black)
                                            .padding(.bottom, -10)
                                        Text("\(selectedTask?.content ?? "")")
                                            .font(.system(.title3, design: .rounded))
                                            .fontWeight(.bold)
                                            .foregroundColor(.black)
                                            .lineLimit(/*@START_MENU_TOKEN@*/15/*@END_MENU_TOKEN@*/)
                                            .frame(maxWidth: 200, maxHeight: 20)
                                        .truncationMode(.tail)
                                    }
                                }
                                .opacity(isFocusMode ? 1 : 0)
                            }
                        }
                        .background(Color(red: 196/255, green: 196/255, blue: 196/255))
                        .cornerRadius(.infinity)
                        
                        ZStack {
                            Button {
//                                isFocusMode.toggle()
                                buttonClicked.toggle()
                            } label: {
                                Text("Start Focus Mode")
                                    .foregroundColor(.black)
                                    .font(.system(.title3, design: .rounded))
                            }
                            .padding(20)
                            .background(Capsule().fill(Color(red: 196/255, green: 196/255, blue: 196/255)).overlay(Capsule().stroke(.black, lineWidth: 3)))
                            .opacity(isFocusMode ? 0 : 1)
                            .sheet(isPresented: $buttonClicked,  content: {
                                NavigationView {
                                    FocusSheetView(selectedTask: $selectedTask, isButtonPressed: $buttonClicked, isFocusMode: $isFocusMode)
                                        .navigationBarTitle(Text("Select Tasks To-Do"), displayMode: .inline)
                                        .navigationBarItems(leading: Button {
                                            print("Dismissing Sheet View")
                                            self.buttonClicked = false
//                                            isFocusMode.toggle()
                                        } label: {
                                            Text("Cancel")
                                                .foregroundColor(.red)
                                        })
                                } //NavigationView
                            }) // Sheet
                            
                            Button {
                                isFocusMode.toggle()
                            } label: {
                                Text("Stop Focus Mode")
                                    .foregroundColor(.black)
                                    .font(.system(.title3, design: .rounded))
                            }
                            .padding(20)
                            .background(Capsule().fill(Color(red: 196/255, green: 196/255, blue: 196/255)).overlay(Capsule().stroke(.black, lineWidth: 3)))
                            .opacity(isFocusMode ? 1 : 0)

                        } //ZStack

                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color(red: 235/255, green: 235/255, blue: 235/255))
                    .cornerRadius(50, corners: [.topLeft, .topRight])
                    .offset(x: 0, y: 10)
                    .alert(isPresented: $isShowAlert) {
                        Alert(title: Text("Focus Mode"), message: Text("Where you able to finish the selected task?"), primaryButton: .default(Text("Yes")) {
                            print("Yes Button Clicked")
                            let oldTaskCompleted = UserDefaults.standard.integer(forKey: "tasksFinished")
                            let newTaskCompleted = oldTaskCompleted + 1
                            UserDefaults.standard.set(newTaskCompleted, forKey: "tasksFinished")
                            isFocusMode.toggle()
                            selectedTask?.isComplete = true
                            do {
                                try context.save()
                            } catch {
                                print(error)
                            }
                            selectedTask = nil
                        }, secondaryButton: .destructive(Text("No")) {
                            print("No Button Clicked")
                            isFocusMode.toggle()
                        })
                    }
                }
            )
    }
}

extension FocusView {
    func getFocusHours() -> Double {
        return (UserDefaults.standard.double(forKey: "focusHrs"))
    }
    
    func getTasksFinished() -> Int {
        return (UserDefaults.standard.integer(forKey: "tasksFinished"))
    }
}

struct FocusView_Previews: PreviewProvider {
    static var previews: some View {
        FocusView(timerClass: TimerClass(minutes: 0, hours: 0))
    }
}
