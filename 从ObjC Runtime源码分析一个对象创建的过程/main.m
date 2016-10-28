//
//  main.m
//  从ObjC Runtime源码分析一个对象创建的过程
//
//  Created by zhf on 16/10/27.
//  Copyright © 2016年 zhenghongfeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/objc-runtime.h>

void sayHello(id self, SEL op, NSString *name) {
    NSLog(@"Hello, %@", name);
}

void initialize(id self,SEL op) { }

id alloc(Class self, SEL op) {
    void *bytes;
    size_t size;
    
    size = class_getInstanceSize(self) + 8; // we used 8 bytes as extra bytes before, so just add it.
    if (size < 16) {
        size = 16;
    }
    
    bytes = calloc(1, size);
    *(unsigned long *) bytes = (unsigned long) self;
    
    id obj = (id) bytes;
    
    return obj;
}

id methodSignatureForSelector(id self, SEL op, SEL sel) { return nil; }

void doesNotRecognizeSelector(id self, SEL op, SEL sel) { NSLog(@"%s", sel_getName(sel)); }





int main(int argc, const char * argv[]) {
    
    // 动态创建一个类Foo
    Class Foo = objc_allocateClassPair(NULL, "Foo", 8);
    class_addMethod(Foo, @selector(sayHello:), (IMP) sayHello, "v@:*");
    class_addMethod(Foo, @selector(initialize), (IMP) initialize, "v@:*");
    class_addMethod(Foo, @selector(alloc), (IMP) alloc, "@@:");
    class_addMethod(Foo, @selector(methodSignatureForSelector:), (IMP) methodSignatureForSelector, "@@::");
    class_addMethod(Foo, @selector(doesNotRecognizeSelector:), (IMP) doesNotRecognizeSelector, "@@::");
    objc_registerClassPair(Foo);
    
    id foo = [Foo alloc];
    ((void (*)(id, SEL, void *)) objc_msgSend)(foo, @selector(sayHello:), @"Cyandev");
    
    
    return 0;
}




















