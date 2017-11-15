import UIKit

struct StyleSheet {
  var text = TextStyleSheet()
}

struct TextStyleSheet {
  var title: TextStyleProtocol = TextStyle().withFont(.boldSystemFont(ofSize: 30))
  var subtitle: TextStyleProtocol = TextStyle().ofSize(20)
  var heading1: TextStyleProtocol = TextStyle().withFont(.boldSystemFont(ofSize: 18))
  var heading2: TextStyleProtocol = TextStyle().withFont(.boldSystemFont(ofSize: 16))
  var heading3: TextStyleProtocol = TextStyle().ofSize(14)
  var headingAccent: TextStyleProtocol = TextStyle().withFont(.boldSystemFont(ofSize: 16)).ofColor(.red)
  var body: TextStyleProtocol = TextStyle()
}
