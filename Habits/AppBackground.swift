//
//  AppBackground.swift
//  Habits
//
//  Created by Ryan on 30/11/2023.
//

import SwiftUI

struct AppBackground: View {
    
    @Environment(\.colorScheme) var scheme
    
    var body: some View {
        
        ZStack {
            
          /*  let grad = Gradient(stops: [.init(color: Color(uiColor: #colorLiteral(red: 0.5960784314, green: 0.4078431373, blue: 0.3019607843, alpha: 1)), location: 0), .init(color: Color(uiColor: #colorLiteral(red: 0.1568627451, green: 0.2235294118, blue: 0.2509803922, alpha: 1)), location: 0.5), .init(color: Color(uiColor: #colorLiteral(red: 0.0431372549, green: 0.1450980392, blue: 0.1725490196, alpha: 1)), location: 1)])
            
            
            LinearGradient(gradient: grad, startPoint: .top, endPoint: .bottom).ignoresSafeArea(.all)
            */
          
            
            if scheme == .dark {
             Color(uiColor: .secondarySystemBackground).ignoresSafeArea(.all)
             } else {
             Color(uiColor: .systemBackground).ignoresSafeArea(.all)
             }
        }
        
    }
}

#Preview {
    AppBackground()
}


struct StaticTextureView: UIViewRepresentable {
    var staticDensity: Int
    var transparency: CGFloat

    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        view.backgroundColor = UIColor.clear
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        let renderer = UIGraphicsImageRenderer(size: uiView.bounds.size)
        let img = renderer.image { ctx in
            for _ in 0..<staticDensity {
                let point = CGPoint(x: CGFloat.random(in: 0...uiView.bounds.width),
                                    y: CGFloat.random(in: 0...uiView.bounds.height))
                ctx.cgContext.setFillColor(UIColor(white: 1.0, alpha: CGFloat.random(in: 0.5...1.0)).cgColor)
                ctx.cgContext.fill(CGRect(origin: point, size: CGSize(width: 1, height: 1)))
            }
        }

        uiView.backgroundColor = UIColor(patternImage: img)
        uiView.alpha = transparency
    }
}
