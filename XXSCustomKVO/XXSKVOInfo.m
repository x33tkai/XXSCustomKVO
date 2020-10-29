//
//  XXSKVOInfo.m
//  XXSCustomKVO
//
//  Created by Admin on 2020/10/29.
//  Copyright © 2020 Admin. All rights reserved.
//

#import "XXSKVOInfo.h"

@implementation XXSKVOInfo

- (instancetype)initWithObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(nullable void *)context block:(LGKVOBlock)block {
    self = [super init];
    if (self) {
        self.observer = observer;
        self.options = options;
        self.handleBlock = block;
        self.keyPath = keyPath;
    }
    return self;
}
@end
