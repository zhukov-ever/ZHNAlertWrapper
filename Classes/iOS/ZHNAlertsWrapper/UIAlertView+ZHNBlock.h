//
//  Block.h
//  ZHNAlertsWrapper
//
//  Created by zhn on 20/07/2015.
//  Copyright (c) 2015 zhn. All rights reserved.
//
//  tnx: http://nscookbook.com/2013/04/ios-programming-recipe-22-simplify-uialertview-with-blocks/
//

#import <UIKit/UIKit.h>


@interface NSCBAlertWrapper : NSObject

@end
@interface UIAlertView(ZHNBlock)

- (void)addCompletion:(void(^)(UIAlertView *alertView, NSInteger buttonIndex))completion;

@end
