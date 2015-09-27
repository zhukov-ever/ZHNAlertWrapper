//
//  AlertController.h
//  ZHNAlertsWrapper
//
//  Created by zhn on 19/05/2015.
//  Copyright (c) 2015 zhn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController(ZHNAlertsWrapper)


- (void) showAlertWithTitle:(NSString*)title
                    message:(NSString*)message;

- (void) showAlertWithTitle:(NSString*)title
                    message:(NSString*)message
              onCloseAction:(void (^)())onCloseAction;

- (void) showAlertWithTitle:(NSString*)title
                    message:(NSString*)message
               buttonTitles:(NSArray*)buttonTitles
              onCloseAction:(void (^)(NSInteger buttonIndex))onCloseAction;

- (void) showActivityAlert;
- (void) hideActivityAlert;

- (void) showCustomView:(UIView*)view
          onCloseAction:(void (^)())onCloseAction;

@end
