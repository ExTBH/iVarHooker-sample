//
//  Deez.h
//  iVarHooker
//
//  Created by Natheer on 28/03/2023.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>


NS_ASSUME_NONNULL_BEGIN

__unsafe_unretained id * readPrivateIvarC(Ivar iVar, id object);

@interface Deez : NSObject

@end

NS_ASSUME_NONNULL_END
