//
//  IvarHooker.m
//  iVarHooker
//
//  Created by Natheer on 28/03/2023.
//
#import "IvarHookerC.h"

static NSString *str1 =@"THis is a String in C Struct";

@implementation IvarHookerC
- (struct HumanReplica1T1C)getStruct {
    struct HumanReplica1T1C hc1;
    hc1.age = 15;
    hc1.name = (__bridge void*)str1;
    return hc1;
}

@end
