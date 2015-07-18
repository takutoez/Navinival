//
//  MapNative.mm
//  Navinival
//
//  Created by 六車卓土 on 2015/05/17.
//
//

#include "MapNative.h"
#include "MyAppDelegate.h"

void MapNative::mapData(int x, int y, int floor)
{
    MyAppDelegate *delegate = (MyAppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate mapDataX:x withY:y withFloor:floor];
}