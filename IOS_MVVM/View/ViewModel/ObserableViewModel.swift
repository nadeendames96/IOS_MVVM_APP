//
//  ObserableViewModel.swift
//  IOS_MVVM
//
//  Created by Nadeen on 20/09/2022.
//

import Foundation
// create obserable class
class Obserable<T>{
    var value:T?{
        // subscribe any change
        didSet{
            listener?(value)
        }
    }
    init(_ value:T?){
        self.value=value
        }
    // create listerner clousre function
    var listener:((T?) -> Void)?
    
    // create binding closure function
    func bind(_ listener: @escaping (T?) -> Void)
    {
        listener(value)
        self.listener = listener
    }
}
