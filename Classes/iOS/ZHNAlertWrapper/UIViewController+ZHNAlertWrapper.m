//
//  AlertController.m
//  ZHNAlertWrapper
//
//  Created by zhn on 19/05/2015.
//  Copyright (c) 2015 zhn. All rights reserved.
//

#import "UIViewController+ZHNAlertWrapper.h"
#import "ZHNAlertProtocol.h"
#import "UIAlertView+ZHNBlock.m"

#import <objc/runtime.h>
#import <CoreGraphics/CoreGraphics.h>

#import "MBProgressHUD.h"


#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)


static void *kArrayAlertsPointer;
static void *kHUDPointer;


@implementation UIViewController(ZHNAlertWrapper)


- (void) showAlertWithTitle:(NSString*)title
                    message:(NSString*)message
{
    [self showAlertWithTitle:title message:message onCloseAction:nil];
}

- (void) showAlertWithTitle:(NSString *)title
                    message:(NSString *)message
              onCloseAction:(void (^)())onCloseAction
{
    [self showAlertWithTitle:title message:message buttonTitles:@[@"Ок"] onCloseAction:onCloseAction];
}

- (void) showAlertWithTitle:(NSString*)title
                    message:(NSString*)message
               buttonTitles:(NSArray*)buttonTitles
              onCloseAction:(void (^)(NSInteger buttonIndex))onCloseAction
{
    [self showAlertWithTitle:title message:message buttonTitles:buttonTitles cancelTitle:nil style:UIAlertControllerStyleAlert onCloseAction:onCloseAction];
    
}

- (void) showAlertWithTitle:(NSString*)title
                    message:(NSString*)message
               buttonTitles:(NSArray*)buttonTitles
                cancelTitle:(NSString*)cancelTitle
                      style:(UIAlertControllerStyle)style
              onCloseAction:(void (^)(NSInteger buttonIndex))onCloseAction
{
    if (SYSTEM_VERSION_LESS_THAN(@"8.0"))
    {
        UIAlertView* _alert = [[UIAlertView alloc] initWithTitle:title
                                                             message:message
                                                            delegate:self
                                                   cancelButtonTitle:nil
                                                   otherButtonTitles:nil];
        for (NSString* _buttonTitle in buttonTitles)
        {
            [_alert addButtonWithTitle:_buttonTitle];
        }
        
        [_alert addCompletion:^(UIAlertView *alertView, NSInteger buttonIndex) {
            [self showNextAlert];
            
            if (onCloseAction)
                onCloseAction(buttonIndex);
        }];
        
        [self addAlert:_alert];
    }
    else
    {
        __block UIAlertController* _alert = [UIAlertController alertControllerWithTitle:title
                                                                                message:message
                                                                         preferredStyle:style];
        for (NSInteger i = 0; i < [buttonTitles count]; i++)
        {
            NSString* _buttonTitle = buttonTitles[i];
            UIAlertAction* _actionClose = [UIAlertAction actionWithTitle:_buttonTitle
                                                                   style:(UIAlertActionStyleDefault)
                                                                 handler:^(UIAlertAction *action)
                                           {
                                               [self showNextAlert];
                                               
                                               if (onCloseAction)
                                                   onCloseAction(i);
                                           }];
            [_alert addAction:_actionClose];
        }
        if (cancelTitle)
        {
            UIAlertAction* _actionCancel = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [self showNextAlert];
                
                if (onCloseAction)
                    onCloseAction([buttonTitles count]);
            }];
            [_alert addAction:_actionCancel];
        }
        
        [self addAlert:_alert];
    }
    

}



- (void) showActivityAlert
{
    if ([[self arrayAlerts] count] > 0)
        return;
    
    MBProgressHUD* _hud = [self HUDAlert];
    [_hud show:YES];
}

- (void) hideActivityAlert
{
    MBProgressHUD* _hud = [self HUDAlert];
    [_hud hide:YES];
}

- (void) showCustomView:(id)view
          onCloseAction:(void (^)())onCloseAction;
{
    if ([view isKindOfClass:[UIView class]])
    {
        if (![view conformsToProtocol:@protocol(ZHNAlertProtocol)])
        {
            NSAssert(false, @"view must realize ZHNAlertProtocol");
            return;
        }
        id<ZHNAlertProtocol> _alert = (id)view;
        [_alert onClose:^{
            [self showNextAlert];
            if (onCloseAction)
                onCloseAction();
        }];
        
        [self addAlert:view];
    }
}



#pragma mark - private

- (void) showNextAlert
{
    if ([[self arrayAlerts] count] > 0)
    {
        [[self arrayAlerts] removeObjectAtIndex:0];
        if ([[self arrayAlerts] count] > 0)
        {
            id _alert = [[self arrayAlerts] firstObject];
            [self showAlert:_alert];
        }
    }
}

- (void) addAlert:(id)alert
{
    if (alert)
    {
        if ([[self arrayAlerts] count] == 0)
            [self showAlert:alert];
        
        [[self arrayAlerts] addObject:alert];
    }
}

- (void) showAlert:(id)alert
{
    [self hideActivityAlert];
    
    if ([alert isKindOfClass:[UIAlertController class]])
    {
        [self presentViewController:alert animated:YES completion:nil];
    }
    else if ([alert conformsToProtocol:@protocol(ZHNAlertProtocol)] &&
             [alert isKindOfClass:[UIView class]])
    {
        UIView* _alertView = (id)alert;
        _alertView.frame = CGRectMake((CGRectGetWidth([UIScreen mainScreen].bounds) - CGRectGetWidth(_alertView.frame))/2.0,
                                      (CGRectGetHeight([UIScreen mainScreen].bounds) - CGRectGetHeight(_alertView.frame))/2.0,
                                      CGRectGetWidth(_alertView.frame),
                                      CGRectGetHeight(_alertView.frame));
        _alertView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        
        UIWindow* _window = [[UIApplication sharedApplication] keyWindow];
        [_window addSubview:_alertView];
    }
    else if ([alert isKindOfClass:[UIAlertView class]])
    {
        [alert show];
    }
    else
    {
        NSAssert(false, @"unknown alert type");
    }
}



- (NSMutableArray*)arrayAlerts
{
    NSMutableArray *_result = objc_getAssociatedObject(self, &kArrayAlertsPointer);
    if (_result == nil)
    {
        _result = [NSMutableArray new];
        objc_setAssociatedObject(self, &kArrayAlertsPointer, _result, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return _result;
}

- (MBProgressHUD*) HUDAlert
{
    MBProgressHUD *HUD = objc_getAssociatedObject(self, &kHUDPointer);
    if (HUD == nil)
    {
        UIView* _keyWindow = [[UIApplication sharedApplication] keyWindow];
        
        HUD = [[MBProgressHUD alloc] initWithView:_keyWindow];
        objc_setAssociatedObject(self, &kHUDPointer, HUD, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        HUD.mode = MBProgressHUDModeCustomView;
        
        [_keyWindow addSubview:HUD];
        
        HUD.dimBackground = YES;
        HUD.color = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.90];
        
        HUD.labelColor = [UIColor blackColor];
        HUD.labelText = @"";
        
        UIActivityIndicatorView* _indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _indicator.color = [UIColor blackColor];
        [_indicator startAnimating];
        [_indicator setHidden:NO];
        HUD.customView = _indicator;
    }
    return HUD;
}

@end
