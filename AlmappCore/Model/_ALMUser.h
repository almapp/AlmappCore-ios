// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ALMUser.h instead.

#import <CoreData/CoreData.h>

extern const struct ALMUserAttributes {
	__unsafe_unretained NSString *admin;
	__unsafe_unretained NSString *country;
	__unsafe_unretained NSString *email;
	__unsafe_unretained NSString *findeable;
	__unsafe_unretained NSString *lastSeen;
	__unsafe_unretained NSString *male;
	__unsafe_unretained NSString *name;
	__unsafe_unretained NSString *student_id;
	__unsafe_unretained NSString *username;
	__unsafe_unretained NSString *webId;
} ALMUserAttributes;

@interface ALMUserID : NSManagedObjectID {}
@end

@interface _ALMUser : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) ALMUserID* objectID;

@property (nonatomic, strong) NSNumber* admin;

@property (atomic) BOOL adminValue;
- (BOOL)adminValue;
- (void)setAdminValue:(BOOL)value_;

//- (BOOL)validateAdmin:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* country;

//- (BOOL)validateCountry:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* email;

//- (BOOL)validateEmail:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* findeable;

@property (atomic) BOOL findeableValue;
- (BOOL)findeableValue;
- (void)setFindeableValue:(BOOL)value_;

//- (BOOL)validateFindeable:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSDate* lastSeen;

//- (BOOL)validateLastSeen:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* male;

@property (atomic) BOOL maleValue;
- (BOOL)maleValue;
- (void)setMaleValue:(BOOL)value_;

//- (BOOL)validateMale:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* name;

//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* student_id;

//- (BOOL)validateStudent_id:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* username;

//- (BOOL)validateUsername:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* webId;

@property (atomic) int32_t webIdValue;
- (int32_t)webIdValue;
- (void)setWebIdValue:(int32_t)value_;

//- (BOOL)validateWebId:(id*)value_ error:(NSError**)error_;

@end

@interface _ALMUser (CoreDataGeneratedPrimitiveAccessors)

- (NSNumber*)primitiveAdmin;
- (void)setPrimitiveAdmin:(NSNumber*)value;

- (BOOL)primitiveAdminValue;
- (void)setPrimitiveAdminValue:(BOOL)value_;

- (NSString*)primitiveCountry;
- (void)setPrimitiveCountry:(NSString*)value;

- (NSString*)primitiveEmail;
- (void)setPrimitiveEmail:(NSString*)value;

- (NSNumber*)primitiveFindeable;
- (void)setPrimitiveFindeable:(NSNumber*)value;

- (BOOL)primitiveFindeableValue;
- (void)setPrimitiveFindeableValue:(BOOL)value_;

- (NSDate*)primitiveLastSeen;
- (void)setPrimitiveLastSeen:(NSDate*)value;

- (NSNumber*)primitiveMale;
- (void)setPrimitiveMale:(NSNumber*)value;

- (BOOL)primitiveMaleValue;
- (void)setPrimitiveMaleValue:(BOOL)value_;

- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;

- (NSString*)primitiveStudent_id;
- (void)setPrimitiveStudent_id:(NSString*)value;

- (NSString*)primitiveUsername;
- (void)setPrimitiveUsername:(NSString*)value;

- (NSNumber*)primitiveWebId;
- (void)setPrimitiveWebId:(NSNumber*)value;

- (int32_t)primitiveWebIdValue;
- (void)setPrimitiveWebIdValue:(int32_t)value_;

@end
