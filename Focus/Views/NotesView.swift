//
//  NotesView.swift
//  Focus
//
//  Created by Aahish Balimane on 4/6/22.
//

import SwiftUI

struct NotesView: View {
    @Environment(\.managedObjectContext) var context
    
    @FetchRequest(entity: NoteItem.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \NoteItem.dateModified, ascending: false)])
    
    var notesList: FetchedResults<NoteItem>
    
    @State private var showNewNote = false
    @State private var editNote = false
    @State var selectedNote: NoteItem?
    
    var twoColGrid = [GridItem(.flexible()), GridItem(.flexible())]
    
    var gridItems: [GridItem] {
        Array(repeating: .init(.adaptive(minimum: 120)), count: 2)
    }
    
    var body: some View {
        Color(red: 70/255, green: 70/255, blue: 70/255)
            .edgesIgnoringSafeArea(.all)
            .overlay(
                ZStack {
                    VStack {
                        HStack {
                            Text("Notes")
                                .foregroundColor(.white)
                                .font(.system(.title, design: .rounded))
                            .fontWeight(.semibold)
                            .padding()
                            
                            Spacer()
                        }
                        
                        VStack {
                            VStack {
                                HStack {
                                    Spacer()
                                    
                                    Button {
                                        showNewNote.toggle()
                                    } label: {
                                        HStack {
                                            Text("+ New Item")
                                                .fontWeight(.bold)
                                                .foregroundColor(.blue)
                                        }
                                    }
                                    .foregroundColor(.black)
                                    .frame(maxWidth: 150, maxHeight: 60)
                                    .background(.white)
                                    .cornerRadius(.infinity)
                                    .padding(.horizontal)
                                .padding(.top)
                                }

                                ScrollView(.vertical, showsIndicators: true) {
                                    LazyVGrid(columns: twoColGrid) {
                                        ForEach(notesList) {
                                            note in
                                            
                                            NoteCellView(item: note)
                                                .onTapGesture {
                                                    print(note.heading)
                                                    print(note.body)
                                                    selectedNote = note
                                                    editNote = true
                                                }
                                                .frame(minHeight: 150, maxHeight: 150)
                                                .background(.white)
                                                .cornerRadius(20)
                                        }
                                    }
                                }
                                .padding(.horizontal)
                                .frame(maxHeight: 550)
                                
                                Spacer()
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color(red: 235/255, green: 235/255, blue: 235/255))
                        .cornerRadius(50, corners: [.topLeft, .topRight])
                        .offset(x: 0, y: 10)
                    }
                    .rotation3DEffect(Angle(degrees: showNewNote ? 5 : 0), axis: (x: 1, y: 0, z: 0))
                    .offset(y: showNewNote ? -50 : 0)
                    .animation(.easeOut)
                    
                    if showNewNote {
                        BlankView(bgColor: .black)
                            .opacity(0.5)
                            .onTapGesture {
                                self.showNewNote = false
                            }

                        NewNoteView(isShow: $showNewNote, heading: "", bodyStr: "", dateModified: Date.now)                            .transition(.move(edge: .bottom))
                            .animation(.interpolatingSpring(stiffness: 200.0, damping: 25.0, initialVelocity: 10.0))
                    }
                    
                    if editNote {
                        EditNoteView(isShow: $editNote, noteItem: $selectedNote, heading: selectedNote!.heading, bodyStr: selectedNote!.body)
                    }
                }
            )
//            .edgesIgnoringSafeArea(.bottom)
    }
}

struct NoteCellView: View {
    @ObservedObject var item: NoteItem
    
    var body: some View {
        VStack {
            HStack {
                Text("\(item.heading)")
                    .fontWeight(.bold)
                Spacer()
            }
            HStack {
                Text("\(item.body)")
                Spacer()
            }
        }
        .padding()
        
    }
}

struct NotesView_Previews: PreviewProvider {
    static var previews: some View {
        NotesView()
    }
}
