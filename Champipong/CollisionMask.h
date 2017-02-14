//
//  CollisionMask.h
//  Champipong
//
//  Created by David on 26/10/16.
//  Copyright © 2016 David. All rights reserved.
//

typedef NS_OPTIONS(NSUInteger, CollisionCategory)
{
    CollisionCategoryMushroom = 0,
    CollisionCategoryPrawn = 1 << 0,
    CollisionCategoryPlayerBread = 1 << 1,
    CollisionCategoryMushroomClip = 1 << 2,
    CollisionCategoryPrawnClip = 1 << 3,
};
