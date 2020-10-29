//
//  XXSKVOInfo.h
//  XXSCustomKVO
//
//  Created by Admin on 2020/10/29.
//  Copyright © 2020 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^LGKVOBlock)(id observer,NSString *keyPath,id oldValue,id newValue);

@interface XXSKVOInfo : NSObject
@property(nonatomic, copy) NSString *keyPath;
@property(nonatomic, assign) NSKeyValueObservingOptions options;
@property(nonatomic, weak) NSObject *observer;
@property (nonatomic, copy) LGKVOBlock  handleBlock;

- (instancetype)initWithObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(nullable void *)context block:(LGKVOBlock)block;
@end

NS_ASSUME_NONNULL_END
