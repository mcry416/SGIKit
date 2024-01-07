//
//  PThread.swift
//  ComplexCamera
//
//  Created by Eldest's MacBook on 2023/5/20.
//

import Foundation

// MARK: - PThreadLock

final public class PThreadLock {
    
    private var recursiveMutex: pthread_mutex_t = pthread_mutex_t()
    private var recursiveMutexAttr: pthread_mutexattr_t = pthread_mutexattr_t()
    
    public init() {
        pthread_mutexattr_init(&recursiveMutexAttr)
        pthread_mutexattr_settype(&recursiveMutexAttr, PTHREAD_MUTEX_RECURSIVE)
        pthread_mutex_init(&recursiveMutex, &recursiveMutexAttr)
    }
    
    deinit {
        pthread_mutexattr_destroy(&recursiveMutexAttr)
    }
    
    /** Method of `lock()` is paired with method of `unlock()`. */
    @inline(__always)
    public final func lock() {
        pthread_mutex_lock(&recursiveMutex)
    }
    
    /** Method of `unlock()` is paired with method of `lock()`. */
    @inline(__always)
    public final func unlock() {
        pthread_mutex_unlock(&recursiveMutex)
    }
    
    /** Method of `tryLock()` is paired with method of `tryUnlock()`. */
    @inline(__always)
    public final func tryLock() {
        pthread_mutex_trylock(&recursiveMutex)
    }
    
    /** Method of `tryUnlock()` is paired with method of `tryLock()`. */
    @inline(__always)
    public final func tryUnlock() {
        pthread_mutex_unlock(&recursiveMutex)
    }
    
}

// MARK: - PThreadRWLock

final public class PThreadRWLock {
    
    private var rwLock: pthread_rwlock_t = pthread_rwlock_t()
    
    public init() {
        if pthread_rwlock_init(&rwLock, nil) != 0 {
            fatalError("PThreadRWLock initlized failed, check the variable of `rwLock`. ")
        }
    }
    
    deinit {
        pthread_rwlock_destroy(&rwLock)
    }
    
    @inline(__always)
    public final func readLock() {
        pthread_rwlock_rdlock(&rwLock)
    }
    
    @inline(__always)
    public final func writeLock() {
        pthread_rwlock_wrlock(&rwLock)
    }
    
    @inline(__always)
    public final func tryReadLock() {
        pthread_rwlock_tryrdlock(&rwLock)
    }
    
    @inline(__always)
    public final func tryWriteLock() {
        pthread_rwlock_trywrlock(&rwLock)
    }
    
    @inline(__always)
    public final func unlock() {
        pthread_rwlock_unlock(&rwLock)
    }
    
}

// MARK: - SGSpinLock

final public class SGSpinLock {
    
    private var locked: Int = 0
    
    @inline(__always)
    public final func lock() {
        while !OSAtomicCompareAndSwapLongBarrier(0, 1, &locked) {
        }
    }
    
    @inline(__always)
    public final func unlock() {
        OSAtomicCompareAndSwapLongBarrier(1, 0, &locked)
    }
    
}

// MARK: - SGRecursiveLock

final public class SGRecursiveLock {
    
    private var thread: UnsafeMutableRawPointer?
    private var count: Int = 0
    
    @inline(__always)
    public final func lock() {
        if OSAtomicCompareAndSwapPtrBarrier(pthread_self(), pthread_self(), &thread) {
            count += 1
            return
        }
        while !OSAtomicCompareAndSwapPtrBarrier(nil, pthread_self(), &thread) {
            usleep(10)
        }
    }
    
    @inline(__always)
    public final func unlock() {
        if count > 0 {
            count -= 1
        } else {
            OSAtomicCompareAndSwapPtrBarrier(pthread_self(), nil, &thread)
        }
    }
    
}
