//
//  ZHNAlertWrapper.h
//  ZHNAlertWrapper
//
//  Created by zhn on 20/07/2015.
//  Copyright (c) 2015 zhn. All rights reserved.
//
//  tnx: http://nscookbook.com/2013/04/ios-programming-recipe-22-simplify-uialertview-with-blocks/
//

#import <UIKit/UIKit.h>

@interface ZHNAlertWrapper : NSObject

@property (copy) void(^completionBlock)(UIAlertView *alertView, NSInteger buttonIndex);

@end
