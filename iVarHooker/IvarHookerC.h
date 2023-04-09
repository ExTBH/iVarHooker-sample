//
//  IvarHooker.h
//  iVarHooker
//
//  Created by Natheer on 28/03/2023.
//

#import <Foundation/Foundation.h>

struct HumanReplica1T1C {
    NSString *name;
    int age;
};

NS_ASSUME_NONNULL_BEGIN

@interface IvarHookerC : NSObject
- (struct HumanReplica1T1C)getStruct;
@end

NS_ASSUME_NONNULL_END
