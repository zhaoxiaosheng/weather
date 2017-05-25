//
//  Single.m
//  GodBlanket
//
//  Created by Z_小圣 on 15/12/12.


#import "Single.h"
static Single *s=nil;
@implementation Single
+(instancetype)shareSingle
{
    if (s==nil) {
        s=[[Single alloc]init];
    }
    return s;
}

@end
