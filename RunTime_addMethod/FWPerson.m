
//
//  FWPerson.m
//  RunTime_addMethod
//
//  Created by 孔凡伍 on 15/8/26.
//  Copyright (c) 2015年 kongfanwu. All rights reserved.
//

#import "FWPerson.h"
#import "FWTagModel.h"

@implementation FWPerson

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.tagModel = [[FWTagModel alloc] init];

    }
    return self;
}

- (void)setTagModel:(FWTagModel *)tagModel
{
    _tagModel = tagModel;
}

@end
