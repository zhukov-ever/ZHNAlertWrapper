//
//  ViewController.m
//  ZHNAlertWrapper
//
//  Created by zhn on 19/05/2015.
//  Copyright (c) 2015 home. All rights reserved.
//

#import "ViewController.h"
#import "UIViewController+ZHNAlertWrapper.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor lightGrayColor];
}

- (IBAction)handler:(id)sender {
    [self showActivityAlert];
    
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(showAlertHandler:) userInfo:nil repeats:NO];
}

- (void) showAlertHandler:(id)sender {
    for (NSInteger i = 0; i < 3; i++) {
        [self showAlertWithTitle:@"Stack of alerts" message:[NSString stringWithFormat:@"message %@", @(i)]];
    }
    [self showAlertWithTitle:@"Title" message:@"last one" buttonTitles:@[@"wow", @"'oh"] onCloseAction:^(NSInteger buttonIndex) {
        if (buttonIndex == 0)
            [self.view setBackgroundColor:[UIColor yellowColor]];
        else
            [self.view setBackgroundColor:[UIColor redColor]];
    }];
    [self showAlertWithTitle:@"With array of buttons"
                     message:@"last one"
                buttonTitles:@[@"ok", @"kek kek ekkek", @"i don't care"]
                 cancelTitle:@"cancel"
                       style:UIAlertControllerStyleActionSheet
               onCloseAction:^(NSInteger buttonIndex)
    {
        NSLog(@"%@", @(buttonIndex));
        
        [self showAlertWithTitle:@"title" message:[NSString stringWithFormat:@"button index was pressed: %@", @(buttonIndex)]];
        self.view.backgroundColor = [UIColor lightGrayColor];
    }];
}


@end
