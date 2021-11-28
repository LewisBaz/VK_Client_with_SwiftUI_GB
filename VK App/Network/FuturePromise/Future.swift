//
//  Future.swift
//  VK App
//
//  Created by Lev Bazhkov on 12.08.2021.
//

import UIKit
import PromiseKit

class Future<T> {
   // Будущее значение имеет три состояния:
   //      - опциональный nil, когда результат еще неизвестен;
   //      - .success(T), успешно полученный результат;
   //      - .failure(Error), ошибка.
    var result: Swift.Result <T, Error>? {
       // Когда значение будет получено, мы должны вызвать все накопленные callback
       didSet {
           guard let result = result else { return }
           callbacks.forEach { $0(result) }
       }
   }
    private var callbacks = [(Swift.Result<T, Error>) -> Void]()
  
    func add(callback: @escaping (Swift.Result<T, Error>) -> Void) {
       callbacks.append(callback)
      
       // Если результат уже доступен — вызываем callback сразу
       result.map(callback)
   }
}

extension Future {
    @discardableResult
   func map<NewType>(with closure: @escaping (T) throws -> NewType) -> Future<NewType> {
       let promise = Promise<NewType>()
    
       // Добавляем callback к существующему Future
       add(callback: { result in
           switch result {
           case .success(let value):
               do {
                   // Когда значение готово, применяем к нему
                   // модифицирующее замыкание и выполняем обещание
                   let mappedValue = try closure(value)
                   promise.fulfill(with: mappedValue)
               } catch {
                   promise.reject(with: error)
               }
           case .failure(let error):
               promise.reject(with: error)
           }
       })

       return promise
   }
}

extension Future {
    @discardableResult
   func flatMap<NewType>(with closure: @escaping (T) throws -> Future<NewType>) -> Future<NewType> {
      
       let promise = Promise<NewType>()
      
       // Добавляем callback к существующему Future
       add(callback: { result in
           switch result {
           case .success(let value):
               do {
                   // Когда значение первого Promise получено,
                   // на его основе генерируем новый Promise
                   let chainedPromise = try closure(value)
                   // и добавляем к нему новый callback
                   chainedPromise.add(callback: { result in
                       switch result {
                       case .success(let value):
                           promise.fulfill(with: value)
                       case .failure(let error):
                           promise.reject(with: error)
                       }
                   })
               } catch {
                   promise.reject(with: error)
               }
           case .failure(let error):
               promise.reject(with: error)
           }
       })
      
       return promise
   }
}

