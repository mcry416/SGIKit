//
//  CachePool.swift
//  EHICompent
//
//  Created by MengQingyu iMac on 2022/7/22.
//

import Foundation

class CachePool<T>: NSObject{
    
    enum DataStructureType {
        case stack
        case queue
    }
    
    private var type: DataStructureType?
    
    private var capacity: Int!
    
    private var cacheStack: CacheStack<T>?
    
    private var cacheQueue: CacheQueue<T>?
    
    init(type: DataStructureType, capacity: Int){
        super.init()
        
        switch type {
        case .stack:
            self.type = .stack
            self.capacity = capacity
    
        case .queue:
            self.type = .queue
            self.capacity = capacity
        }
        
        initPool()
    }
    
    private func initPool(){
        switch type {
        case .queue:
            break
        case .stack:
            break
        case .none:
            break
        }
    }
    
}

extension CachePool{
    
    /**
     Insert a specified data structure features data. An element that over capacity will be truncate others element to save itself.
     */
    public func add(_ data: T){
        switch self.type {
        case .stack:
            if cacheStack!.count <= self.capacity! {
                cacheStack!.push(element: data)
            } else {
                remove()
            }
        case .queue:
            if cacheQueue!.count <= self.capacity {
                cacheQueue!.enqueue(element: data)
            } else {
                remove()
            }
        case .none:
            break
        }
    }
    
    /**
     Remove a specified data structure features data.
     */
    public func remove(){
        switch self.type {
        case .stack:
            cacheStack?.pop()
        case .queue:
            cacheQueue?.dequeue()
        case .none:
            break
        }
    }
    
    /**
     Return data structure head data if existanced.
     */
    public func getHead() -> T?{
        switch self.type {
        case .stack:
            return cacheStack?.pop()
        case .queue:
            return cacheQueue?.dequeue()
        case .none:
            break
        }
        return nil
    }
    
    /**
     Return data structure tail data if existanced.
     */
    public func getTail() -> T?{
        switch self.type {
        case .stack:
            return cacheStack?.pop()
        case .queue:
            return cacheQueue?.dequeue()
        case .none:
            break
        }
        return nil
    }
    
    /**
     Return data structure capacity.
     */
    public func getCapacity() -> Int{
        switch self.type {
        case .stack:
            return cacheStack?.capacity ?? 0
        case .queue:
            return cacheQueue?.capacity ?? 0
        case .none:
            break
        }
        return 0
    }
    
    /**
     Return data structure count.
     */
    public func getCount() -> Int{
        switch self.type {
        case .stack:
            return cacheStack?.count ?? 0
        case .queue:
            return cacheQueue?.count ?? 0
        case .none:
            break
        }
        return 0
    }
    
    /**
     Increase or decrease data structure capacity.
     */
    public func setCapacity(_ value: Int){
        switch self.type {
        case .stack:
            cacheStack?.capacity = value
        case .queue:
            cacheQueue?.capacity = value
        case .none:
            break
        }
    }
    
    /**
     Clear all data.
     */
    public func setClear(){
        switch self.type {
        case .stack:
            cacheStack?.count.words.forEach({ count in
                self.cacheStack?.pop()
            })
        case .queue:
            cacheQueue?.clear()
        case .none:
            break
        }
    }
}
