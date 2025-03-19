import SwiftUI

struct PersonDetailView: View {
    let person: Person
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("CNP: ")
                    .fontWeight(.bold)
                Text(person.cnp)
            }
            HStack {
                Text("ID Series: ")
                    .fontWeight(.bold)
                Text(person.idSeries)
            }
            HStack {
                Text("ID Number: ")
                    .fontWeight(.bold)
                Text(person.idNumber)
            }
            HStack {
                Text("First Name: ")
                    .fontWeight(.bold)
                Text(person.firstName)
            }
            HStack {
                Text("Last Name: ")
                    .fontWeight(.bold)
                Text(person.lastName)
            }
        }
        .padding()
    }
}
