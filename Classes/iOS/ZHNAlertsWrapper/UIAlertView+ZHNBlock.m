//
//  Block.m
//  ZHNAlertsWrapper
//
//  Created by zhn on 20/07/2015.
//  Copyright (c) 2015 zhn. All rights reserved.
//
//  tnx: http://nscookbook.com/2013/04/ios-programming-recipe-22-simplify-uialertview-with-blocks/
//

#import "UIAlertView+ZHNBlock.h"
#import "ZHNAlertWrapper.h"
#import <objc/runtime.h>


static const char kZHNAlertWrapper;
@implementation UIAlertView(ZHNBlock)

- (void) addCompletion:(void(^)(UIAlertView *alertView, NSInteger buttonIndex))completion
{
    ZHNAlertWrapper *_alertWrapper = [[ZHNAlertWrapper alloc] init];
    _alertWrapper.completionBlock = completion;
    self.delegate = _alertWrapper;
    
    objc_setAssociatedObject(self, &kZHNAlertWrapper, _alertWrapper, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
