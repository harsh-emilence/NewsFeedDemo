//
//  Bindable.swift
//  NewsFeedDemo
//
//  Created by Zimble on 06/03/20.
//



import UIKit
import Foundation

class Bindable<T> {
    
    typealias Listener = (T) -> Void
    var listener: Listener?
    
    var value: T? {
        didSet {
            listener?(value!)
        }
    }
    
    init(_ v: T) {
        value = v
    }
    
    func bind(listener: Listener?) {
        
        self.listener = listener
        listener?(value!)
    }
}
