// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ALMUser.m instead.

#import "_ALMUser.h"

const struct ALMUserAttributes ALMUserAttributes = {
	.admin = @"admin",
	.country = @"country",
	.email = @"email",
	.findeable = @"findeable",
	.lastSeen = @"lastSeen",
	.male = @"male",
	.name = @"name",
	.student_id = @"student_id",
	.username = @"username",
	.webId = @"webId",
};

@implementation ALMUserID
@end

@implementation _ALMUser

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"User";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"User" inManagedObjectContext:moc_];
}

- (ALMUserID*)objectID {
	return (ALMUserID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"adminValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"admin"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"findeableValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"findeable"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"maleValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"male"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"webIdValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"webId"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic admin;

- (BOOL)adminValue {
	NSNumber *result = [self admin];
	return [result boolValue];
}

- (void)setAdminValue:(BOOL)value_ {
	[self setAdmin:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveAdminValue {
	NSNumber *result = [self primitiveAdmin];
	return [result boolValue];
}

- (void)setPrimitiveAdminValue:(BOOL)value_ {
	[self setPrimitiveAdmin:[NSNumber numberWithBool:value_]];
}

@dynamic country;

@dynamic email;

@dynamic findeable;

- (BOOL)findeableValue {
	NSNumber *result = [self findeable];
	return [result boolValue];
}

- (void)setFindeableValue:(BOOL)value_ {
	[self setFindeable:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveFindeableValue {
	NSNumber *result = [self primitiveFindeable];
	return [result boolValue];
}

- (void)setPrimitiveFindeableValue:(BOOL)value_ {
	[self setPrimitiveFindeable:[NSNumber numberWithBool:value_]];
}

@dynamic lastSeen;

@dynamic male;

- (BOOL)maleValue {
	NSNumber *result = [self male];
	return [result boolValue];
}

- (void)setMaleValue:(BOOL)value_ {
	[self setMale:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveMaleValue {
	NSNumber *result = [self primitiveMale];
	return [result boolValue];
}

- (void)setPrimitiveMaleValue:(BOOL)value_ {
	[self setPrimitiveMale:[NSNumber numberWithBool:value_]];
}

@dynamic name;

@dynamic student_id;

@dynamic username;

@dynamic webId;

- (int32_t)webIdValue {
	NSNumber *result = [self webId];
	return [result intValue];
}

- (void)setWebIdValue:(int32_t)value_ {
	[self setWebId:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveWebIdValue {
	NSNumber *result = [self primitiveWebId];
	return [result intValue];
}

- (void)setPrimitiveWebIdValue:(int32_t)value_ {
	[self setPrimitiveWebId:[NSNumber numberWithInt:value_]];
}

@end

