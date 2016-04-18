//
//  AlertController.h
//  ZHNAlertWrapper
//
//  Created by zhn on 19/05/2015.
//  Copyright (c) 2015 zhn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController(ZHNAlertWrapper)


- (void) showAlertWithTitle:(NSString*)title
                    message:(NSString*)message;

- (void) showAlertWithTitle:(NSString*)title
                    message:(NSString*)message
              onCloseAction:(void (^)())onCloseAction;

- (void) showAlertWithTitle:(NSString*)title
                    message:(NSString*)message
               buttonTitles:(NSArray*)buttonTitles
              onCloseAction:(void (^)(NSInteger buttonIndex))onCloseAction;

- (void) showAlertWithTitle:(NSString*)title
                    message:(NSString*)message
               buttonTitles:(NSArray*)buttonTitles
                cancelTitle:(NSString*)cancelTitle
                      style:(UIAlertControllerStyle)style
              onCloseAction:(void (^)(NSInteger buttonIndex))onCloseAction;

- (void) showActivityAlert;
- (void) hideActivityAlert;

- (void) showCustomView:(UIView*)view
          onCloseAction:(void (^)())onCloseAction;

@end
