//
//  ZHNAlertWrapper.m
//  ZHNAlertsWrapper
//
//  Created by zhn on 20/07/2015.
//  Copyright (c) 2015 zhn. All rights reserved.
//
//  tnx: http://nscookbook.com/2013/04/ios-programming-recipe-22-simplify-uialertview-with-blocks/
//

#import "ZHNAlertWrapper.h"


@interface ZHNAlertWrapper() <UIAlertViewDelegate>

@end


@implementation ZHNAlertWrapper

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (self.completionBlock)
        self.completionBlock(alertView, buttonIndex);
}

@end
