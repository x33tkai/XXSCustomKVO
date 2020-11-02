//
//  NSObject+XXSKVO.m
//  XXSCustomKVO
//
//  Created by Admin on 2020/10/29.
//  Copyright © 2020 Admin. All rights reserved.
//

#import "NSObject+XXSKVO.h"
#import <objc/message.h>


static NSString *const kLGKVOPrefix = @"LGKVONotifying_";
static NSString *const kLGKVOAssiociateKey = @"kLGKVO_AssiociateKey";


@implementation NSObject (XXSKVO)
- (void)xxs_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(nullable void *)context block:(nonnull LGKVOBlock)block {
    
    // 是否有setter 方法
    SEL setter = NSSelectorFromString(setterForGetter(keyPath));
    Method setterMethod = class_getInstanceMethod([self class], setter);
    if (!setterMethod) {
        return;
    }
    
    // 创建类
    Class newClass = [self createChildClassWithKeyPath:keyPath];
    
    // isa
    object_setClass(self, newClass);
    
    // 添加setter
    const char * type = method_getTypeEncoding(class_getInstanceMethod([self class], setter));
    class_addMethod(newClass, setter, (IMP)xxs_setter, type);
    
    // 缓存info
    XXSKVOInfo *info = [[XXSKVOInfo alloc] initWithObserver:observer forKeyPath:keyPath options:options context:context block:block];
    
    NSMutableArray *array = objc_getAssociatedObject(self, (__bridge const void * _Nonnull)(kLGKVOAssiociateKey));
    if (!array) {
        array = [[NSMutableArray alloc] init];
    }
    [array addObject:info];
    objc_setAssociatedObject(self, (__bridge const void * _Nonnull)(kLGKVOAssiociateKey), array, OBJC_ASSOCIATION_RETAIN);
}

- (Class)createChildClassWithKeyPath:(NSString *)keyPath{
    
    NSString *oldName = NSStringFromClass([self class]);
    NSString *newName = [NSString stringWithFormat:@"%@%@", kLGKVOPrefix, oldName];
    Class newClass = NSClassFromString(newName);
    if (newClass) {
        return newClass;
    }
    
    newClass = objc_allocateClassPair([self class], newName.UTF8String, 0);
    objc_registerClassPair(newClass);
    
    
    // class
    SEL sel = NSSelectorFromString(@"class");
    Method method = class_getInstanceMethod([self class], sel);
    const char * type = method_getTypeEncoding(method);
    class_addMethod(newClass, sel, (IMP)xxs_class, type);
    
    SEL selDealloc = NSSelectorFromString(@"dealloc");
    Method methodDealloc = class_getInstanceMethod([self class], selDealloc);
    const char * typeDealloc = method_getTypeEncoding(methodDealloc);
    class_addMethod(newClass, selDealloc, (IMP)xxs_dealloc, typeDealloc);
    
    return newClass;
}

// setter 方法的实现
static void xxs_setter(id self,SEL _cmd,id newValue){
    NSString *keypath = getterForSetter(NSStringFromSelector(_cmd));
    id oldValue = [self valueForKey:keypath];
    
    // 判断是否开启自动监听
    if (![[self class] automaticallyNotifiesObserversForKey:keypath]) {
        return;
    }
    
    // 父房间发送setter消息
    void (*msgSendSuper)(void*, SEL, id)  = (void *)objc_msgSendSuper;
    struct objc_super superStruct = {
        .receiver = self,
        .super_class = [self class],
    };
    msgSendSuper(&superStruct, _cmd, newValue);
    
    // 执行回调
    NSMutableArray *array = objc_getAssociatedObject(self, (__bridge const void * _Nonnull)(kLGKVOAssiociateKey));
    for (XXSKVOInfo *info in array) {
        if ([info.keyPath isEqualToString:keypath] && info.handleBlock) {
            info.handleBlock(info.observer, keypath, oldValue, newValue);
        }
    }
}

// class 方法的实现
static Class xxs_class(id self,SEL _cmd){
    return class_getSuperclass(object_getClass(self));
}

// delloc 方法的实现
static void xxs_dealloc(id self,SEL _cmd){
    
    Class superClass = [self class];
    object_setClass(self, superClass);
    NSLog(@"isa 指针指回去了");
    
}

#pragma mark - 从get方法获取set方法的名称 key ===>>> setKey:
static NSString *setterForGetter(NSString *getter){
    
    if (getter.length <= 0) { return nil;}
    
    NSString *firstString = [[getter substringToIndex:1] uppercaseString];
    NSString *leaveString = [getter substringFromIndex:1];
    
    return [NSString stringWithFormat:@"set%@%@:",firstString,leaveString];
}

#pragma mark - 从set方法获取getter方法的名称 set<Key>:===> key
static NSString *getterForSetter(NSString *setter){
    
    if (setter.length <= 0 || ![setter hasPrefix:@"set"] || ![setter hasSuffix:@":"]) { return nil;}
    
    NSRange range = NSMakeRange(3, setter.length-4);
    NSString *getter = [setter substringWithRange:range];
    NSString *firstString = [[getter substringToIndex:1] lowercaseString];
    return  [getter stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:firstString];
}
@end
