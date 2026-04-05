//
//  Binding.swift
//  MewNotch
//
//  Created by Monu Kumar on 05/04/26.
//

import SwiftUI

extension Binding {
    
    var animated: Self {
        return Binding(
            get: { self.wrappedValue },
            set: { newValue in
                withAnimation {
                    self.wrappedValue = newValue
                }
            }
        )
    }
}

prefix operator |

public prefix func | <Value>(binding: Binding<Value>) -> Binding<Value> {
    return binding.animated
}
