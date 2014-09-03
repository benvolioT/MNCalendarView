//
//  MNCalendarViewLayoutAttributes.m
//  Pods
//
//  Created by Ben Truitt on 9/2/14.
//
//

#import "MNCalendarViewLayoutAttributes.h"

@implementation MNCalendarViewLayoutAttributes

@synthesize firstDayOfWeek;

- (id) copyWithZone:(NSZone *)zone {
    MNCalendarViewLayoutAttributes *clone = [super copyWithZone:zone];
    [clone setFirstDayOfWeek:[self isFirstDayOfWeek]];
    return clone;
}

@end
