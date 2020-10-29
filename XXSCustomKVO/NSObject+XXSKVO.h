//
//  NSObject+XXSKVO.h
//  XXSCustomKVO
//
//  Created by Admin on 2020/10/29.
//  Copyright © 2020 Admin. All rights reserved.
//



#import <Foundation/Foundation.h>
#import "XXSKVOInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (XXSKVO)
- (void)xxs_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(nullable void *)context block:(LGKVOBlock)block;
@end

NS_ASSUME_NONNULL_END
