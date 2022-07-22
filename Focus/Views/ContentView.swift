//
//  ContentView.swift
//  Focus
//
//  Created by Aahish Balimane on 3/4/22.
//

import SwiftUI

enum Tabs: Hashable {
    case dashboard
    case focus
    case todo
    case notes
}

struct ContentView: View {
    
    @Environment(\.managedObjectContext) var context
    
    @FetchRequest(entity: ToDoItem.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \ToDoItem.priorityNum, ascending: false)])
    
    var toDoList: FetchedResults<ToDoItem>
    
    @FetchRequest(entity: NoteItem.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \NoteItem.heading, ascending: true)])
    
    var notesList: FetchedResults<NoteItem>
    
    @State var selectTab = Tabs.dashboard
    @State var locationManager = LocationManager()
    
    init() {
        UITabBar.appearance().backgroundColor = UIColor.init(red: 235/255, green: 235/255, blue: 235/255, alpha: 1)
        
        UITextView.appearance().backgroundColor = UIColor.systemGray6
    }
    
    var body: some View {
        TabView(selection: $selectTab) {
            DashboardView(locationManager: locationManager)
                .tabItem {
                    Image(systemName: "house")
                    Text("Dashboard")
                }
                .tag(Tabs.dashboard)
            
            FocusView(timerClass: TimerClass(minutes: 0, hours: 0))
                .tabItem {
                    Image(systemName: "moon.stars")
                    Text("Focus")
                }
                .tag(Tabs.focus)
            
            ToDoView()
                .tabItem {
                    Image(systemName: "checkmark.square")
                    Text("To-Do")
                }
            
            NotesView()
                .tabItem {
                    Image(systemName: "note.text")
                    Text("Notes")
                }
        }
        .tint(.white)
    } // Body
} // ContentView

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
