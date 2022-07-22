//
//  DashboardView.swift
//  Focus
//
//  Created by Aahish Balimane on 4/4/22.
//

import SwiftUI

struct DashboardView: View {
    
    @Environment(\.managedObjectContext) var context
    
    @FetchRequest(entity: ToDoItem.entity(), sortDescriptors: [  NSSortDescriptor(keyPath: \ToDoItem.isComplete, ascending: true) ,NSSortDescriptor(keyPath: \ToDoItem.priorityNum, ascending: false)])
    
    var toDoList: FetchedResults<ToDoItem>
    
    @FetchRequest(entity: NoteItem.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \NoteItem.dateModified, ascending: false)])
    
    var notesList: FetchedResults<NoteItem>
    
    var baseURL = "https://api.weatherapi.com/v1/current.json"
    var key = "5dfd1f3f32e7413c8cc173940211710"
    var weatherImageURL: String?
    var temperatureC: Double?
    private var locationManager: LocationManager
    
    @State var selectedNote: NoteItem?
    @State private var editNote = false
        
    init(locationManager: LocationManager) {
        self.locationManager = locationManager
        let lat = locationManager.location?.coordinate.latitude as? Double
        let long = locationManager.location?.coordinate.longitude as? Double
        
        if !(locationManager.permissionsError ?? true) {
            let endpoint = URL(string: "\(baseURL)?key=\(key)&q=\(lat ?? 37.329142),\(long ?? -122.0260794)")
            do {
                let data = try Data(contentsOf: endpoint!)
                if let json = (try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)) as? [String: Any] {
                    if let current = json["current"] as? [String: Any] {
                        let conditions = current["condition"] as! [String: Any]
                        weatherImageURL = conditions["icon"] as? String
                        
                        temperatureC = current["temp_c"] as? Double
                    }
                }
            } catch {
                print(error)
            }
        }
    }
    
    var body: some View {
        Color(red: 70/255, green: 70/255, blue: 70/255)
            .edgesIgnoringSafeArea(.all)
            .overlay(
                ZStack {
                    VStack {
                        HStack {
                            Text("Dashboard")
                                .foregroundColor(.white)
                                .font(.system(.title, design: .rounded))
                            .fontWeight(.semibold)
                            .padding()
                            
                            Spacer()
                        }
                        
                        HStack {
                            VStack(alignment: .leading) {
                                Text(getCurrentDay())
                                    .foregroundColor(.white)
                                    .font(.system(.callout, design: .rounded))

                                Text("\(getCurrentMonth()) \(getCurrentDate())")
                                    .foregroundColor(.white)
                                    .font(.system(.largeTitle, design: .rounded))
                            }
                            .padding()

                            Spacer()

                            if !(locationManager.permissionsError ?? true) {
                                if weatherImageURL != nil && temperatureC != nil {
                                    VStack(spacing: 0) {
                                        ImageView(imageLoader: ImageLoader(urlString: "https:\(weatherImageURL!)"))
                                            .frame(maxWidth: 96, maxHeight: 96)
                                            .padding(.top, -50)
                                        
                                        Text("\(String(format: "%.0f", temperatureC!)) °C")
                                            .font(.system(.largeTitle, design: .rounded))
                                            .foregroundColor(.white)
                                            .offset(x: 0, y: -20)
                                            .padding(.bottom, -30)
                                            .padding(.top, -10)
                                    }
                                    .padding()                                    
                                }
                            }
                        }
                        
                        VStack() {
                            VStack {
                                HStack {
                                    Text("To-Do")
                                        .foregroundColor(.black)
                                        .font(.system(.title2, design: .rounded))
                                        .padding(.horizontal, 30)
                                        .padding(.vertical, -5)
                                    Spacer()
                                }
                                VStack {
                                    if toDoList.isEmpty {
                                        Text("Add To-Do Items to see here!")
                                            .fontWeight(.bold)
                                    }
                                    ForEach(Array(toDoList.enumerated()), id: \.element) {
                                        index, item in
                                        
                                        if index < 2 {
                                            ToDoRowView(item: item)
                                                .padding(10)
                                                .frame(maxWidth: 275, maxHeight: 50)
                                                .background(Color.white)
                                                .cornerRadius(10)
                                        }
                                    }
                                }
                                .frame(maxWidth: .infinity, maxHeight: 175)
                                .background(Color(red: 196/255, green: 196/255, blue: 196/255))
                                .cornerRadius(25)
                                .padding(.horizontal, 30)
                                .padding(.vertical, 0)
                            }
                            .padding(.top, 50)
                            .padding(.bottom, 20)
                            
                            VStack {
                                HStack {
                                    Text("Recent Notes")
                                        .foregroundColor(.black)
                                        .font(.system(.title2, design: .rounded))
                                        .padding(.horizontal, 30)
                                        .padding(.vertical, -5)
                                    Spacer()
                                }
                                HStack {
                                    if notesList.isEmpty {
                                        Text("Add new Notes to see here!")
                                            .fontWeight(.bold)
                                    }
                                    ForEach(Array(notesList.enumerated()), id: \.element) {
                                        index, note in
                                        
                                        if(index < 2) {
                                            NoteCellView(item: note)
                                                .onTapGesture {
                                                    print(note.heading)
                                                    print(note.body)
                                                    selectedNote = note
                                                    editNote = true
                                                }
                                                .frame(maxWidth: 140, maxHeight: 90)
                                                .background(.white)
                                                .cornerRadius(20)               
                                        }

                                    }
                                }
                                .frame(maxWidth: .infinity, maxHeight: 165)
                                .background(Color(red: 196/255, green: 196/255, blue: 196/255))
                                .cornerRadius(25)
                                .padding(.horizontal, 30)
                                .padding(.vertical, 0)
                            }
                            
                            Spacer()
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color(red: 235/255, green: 235/255, blue: 235/255))
                        .cornerRadius(50, corners: [.topLeft, .topRight])
                        .offset(x: 0, y: 10)
                        
                        Spacer()
                    }
                    
                    if editNote {
                        EditNoteView(isShow: $editNote, noteItem: $selectedNote, heading: selectedNote!.heading, bodyStr: selectedNote!.body)
                    }
                }
            ) // Overlay
    }
}

extension DashboardView {
    func getCurrentDay() -> String {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: date)
    }
    
    func getCurrentDate() -> String {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        return dateFormatter.string(from: date)
    }
    
    func getCurrentMonth() -> String {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        return dateFormatter.string(from: date)
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView(locationManager: LocationManager())
//        DashboardView()
    }
}
