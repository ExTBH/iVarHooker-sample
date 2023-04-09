//
//  Deez.m
//  iVarHooker
//
//  Created by Natheer on 28/03/2023.
//

#import "Deez.h"

 __unsafe_unretained id * readPrivateIvarC(Ivar iVar, id object) {
    uintptr_t objectPtr = (uintptr_t)object;
    ptrdiff_t iVarOffset = ivar_getOffset(iVar);
    NSLog(@"objectPtr: %p", objectPtr);
    NSLog(@"iVarOffset: %ld", iVarOffset);
    return (__unsafe_unretained id *)(void *)(objectPtr + iVarOffset);
}



@implementation Deez

@end
