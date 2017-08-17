//
//  BluetoothCommand.h
//  Grunwl
//
//  Created by mojingyu on 16/1/31.
//  Copyright © 2016年 Mojy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BluetoothCommand : NSObject

+ (NSData *)powerOnCommand;
+ (NSData *)powerOffCommand;
+ (NSData *)plusDownCommand;
+ (NSData *)plusUpCommand;
+ (NSData *)reduceDownCommand;
+ (NSData *)reduceUpCommand;

+ (NSData *)readConfigCommand;

+ (NSData *)setA1Command:(CGFloat)value;
+ (NSData *)setA2Command:(CGFloat)value;
+ (NSData *)setA3Command:(CGFloat)value;
+ (NSData *)setA4Command:(CGFloat)value;
+ (NSData *)setA5Command:(CGFloat)value;
+ (NSData *)setA6Command:(CGFloat)value;
+ (NSData *)setA7Command:(CGFloat)value;
+ (NSData *)setA8Command:(CGFloat)value;

+ (NSData *)setA9Command:(CGFloat)value;
+ (NSData *)setA10Command:(CGFloat)value;
+ (NSData *)setA11Command:(CGFloat)value;
+ (NSData *)setA12Command:(CGFloat)value;

+ (NSData *)debugStartCommand;
+ (NSData *)debugStopCommand;
+ (NSData *)debugPlusCommand:(NSInteger)tag;
+ (NSData *)debugReduceCommand:(NSInteger)tag;

+ (NSData *)exitCommand;
+ (NSData *)readSerialNubmerCommand;
+ (NSData *)activeCommand;

+ (NSData *)runMultiPumpCommand;
+ (NSData *)stopMultiPumpCommand;
+ (NSData *)plusMultiPumpCommand;
+ (NSData *)reduceMultiPumpCommand;
+ (NSData *)hiddenCommand;

+ (NSData *)leaveMultiPumpCommand;
+ (NSData *)inMultiPumpCommand;
+ (NSData *)verifyPasswordCommand:(CGFloat)password;
+ (NSData *)changPasswordCommand:(CGFloat)newPassword;
@end
