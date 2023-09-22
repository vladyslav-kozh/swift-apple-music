// Vladislav K.

import SwiftUI

extension View {
    var screenCornerRadius: CGFloat {
        let key = "_displayCornerRadius"
        
        if let screen = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first?.windows.first?.screen,
           let cornerRadius = screen.value(forKey: key) as? CGFloat {
            return cornerRadius
        }
        
        return 0
    }
}
