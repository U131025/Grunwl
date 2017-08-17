//
//  NSData+CRC.h
//  Grunwl
//
//  Created by mojingyu on 16/2/20.
//  Copyright © 2016年 Mojy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (CRC)

- (int32_t)crc32;

- (int16_t)crc16;

@end
