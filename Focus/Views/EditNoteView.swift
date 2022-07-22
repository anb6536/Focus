
import SwiftUI

struct EditNoteView: View {
    @Environment(\.managedObjectContext) var context
    
    @Binding var isShow: Bool
    @Binding var noteItem: NoteItem?
    
    @State var heading: String
    @State var bodyStr: String
    @State var isEditing = false
            
    var body: some View {
        VStack {
            Spacer()
            
            VStack(alignment: .leading) {
                HStack(alignment: .center) {
                    Text("Add a new Note")
                        .font(.system(.title, design: .rounded))
                        .bold()
                    
                    Spacer()
                    
                    // Save button for adding the todo item
                    Button(action: {
                        
                        if self.heading.trimmingCharacters(in: .whitespaces) == "" && self.bodyStr.trimmingCharacters(in: .whitespaces) == ""{
                            return
                        }
                        
                        self.isShow = false
                        self.noteItem!.heading = self.heading
                        self.noteItem!.body = self.bodyStr
                        self.noteItem!.dateModified = Date.now
                        
                        do {
                            try context.save()
                        } catch {
                            print(error)
                        }
                    }) {
                        Text("Save")
                            .font(.system(.headline, design: .rounded))
                            .frame(minWidth: 0, maxWidth: 40)
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
                
                TextField("Title", text: $heading, onEditingChanged: { (editingChanged) in
                    
                    self.isEditing = editingChanged
                    
                })
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .padding(.bottom)
                
                TextEditor(text: $bodyStr)
                    .frame(maxHeight: .infinity)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .padding(.bottom, 30)
                
            }
            .padding()
            .background(Color.white)
            .cornerRadius(10, antialiased: true)
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}


struct EditNoteView_Previews: PreviewProvider {
    static var previews: some View {
        NewNoteView(isShow: .constant(true), heading: "", bodyStr: "", dateModified: Date())
    }
}


