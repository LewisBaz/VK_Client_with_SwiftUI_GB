//
//  Promise.swift
//  VK App
//
//  Created by Lev Bazhkov on 12.08.2021.
//

import UIKit
import PromiseKit

class Promise<T>: Future<T> {
   init(value: T? = nil) {
       super.init()
      
       // Если результат уже доступен, то мы сразу можем положить его
       // в success case нашего Future
       result = value.map(Swift.Result.success)
   }
  
   // Функции для выполнения или нарушения обещания
   func fulfill(with value: T) {
       result = .success(value)
   }
  
   func reject(with error: Error) {
       result = .failure(error)
   }
}
