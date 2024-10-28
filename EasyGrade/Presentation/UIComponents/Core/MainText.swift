import SwiftUI

struct MainText: View {

    var text: String
    var textColor: Color?
    var font: Font
    var fontWeight: Font.Weight?
    var textAlignment: TextAlignment?

    var body: some View {

        Text(text)
            .font(font)
            .foregroundColor(textColor ?? Color(.blue))
            .fontWeight(fontWeight ?? .regular)
            .multilineTextAlignment(textAlignment ?? .leading)
    }
}

struct MainText_Previews: PreviewProvider {
    static var previews: some View {
        MainText(text: "Sample",
                 textColor: .blue,
                 font: .title,
                 fontWeight: .bold,
                 textAlignment: .center)
    }
}
