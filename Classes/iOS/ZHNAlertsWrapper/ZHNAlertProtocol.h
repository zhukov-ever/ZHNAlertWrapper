//
//  Header.h
//  astykzhan
//
//  Created by zhn on 16/07/2015.
//  Copyright (c) 2015 zhn. All rights reserved.
//

#ifndef astykzhan_Header_h
#define astykzhan_Header_h

#import <UIKit/UIKit.h>

@protocol ZHNAlertProtocol <NSObject>

- (void) onClose:(void(^)())closeHandler;

@end

#endif
