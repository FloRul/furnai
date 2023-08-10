/*
* Copyright 2021 Amazon.com, Inc. or its affiliates. All Rights Reserved.
*
* Licensed under the Apache License, Version 2.0 (the "License").
* You may not use this file except in compliance with the License.
* A copy of the License is located at
*
*  http://aws.amazon.com/apache2.0
*
* or in the "license" file accompanying this file. This file is distributed
* on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
* express or implied. See the License for the specific language governing
* permissions and limitations under the License.
*/

// NOTE: This file is generated and may not follow lint rules defined in your app
// Generated files can be excluded from analysis in analysis_options.yaml
// For more info, see: https://dart.dev/guides/language/analysis-options#excluding-code-from-analysis

// ignore_for_file: public_member_api_docs, annotate_overrides, dead_code, dead_codepublic_member_api_docs, depend_on_referenced_packages, file_names, library_private_types_in_public_api, no_leading_underscores_for_library_prefixes, no_leading_underscores_for_local_identifiers, non_constant_identifier_names, null_check_on_nullable_type_parameter, prefer_adjacent_string_concatenation, prefer_const_constructors, prefer_if_null_operators, prefer_interpolation_to_compose_strings, slash_for_doc_comments, sort_child_properties_last, unnecessary_const, unnecessary_constructor_name, unnecessary_late, unnecessary_new, unnecessary_null_aware_assignments, unnecessary_nullable_for_final_variable_declarations, unnecessary_string_interpolations, use_build_context_synchronously

import 'ModelProvider.dart';
import 'package:amplify_core/amplify_core.dart' as amplify_core;


/** This is an auto generated class representing the ImageEntry type in your schema. */
class ImageEntry extends amplify_core.Model {
  static const classType = const _ImageEntryModelType();
  final String id;
  final String? _originalImage;
  final String? _maskImage;
  final String? _owner;
  final amplify_core.TemporalDateTime? _createdOn;
  final amplify_core.TemporalDateTime? _updatedOn;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  ImageEntryModelIdentifier get modelIdentifier {
      return ImageEntryModelIdentifier(
        id: id
      );
  }
  
  String get originalImage {
    try {
      return _originalImage!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String get maskImage {
    try {
      return _maskImage!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String? get owner {
    return _owner;
  }
  
  amplify_core.TemporalDateTime? get createdOn {
    return _createdOn;
  }
  
  amplify_core.TemporalDateTime? get updatedOn {
    return _updatedOn;
  }
  
  const ImageEntry._internal({required this.id, required originalImage, required maskImage, owner, createdOn, updatedOn}): _originalImage = originalImage, _maskImage = maskImage, _owner = owner, _createdOn = createdOn, _updatedOn = updatedOn;
  
  factory ImageEntry({String? id, required String originalImage, required String maskImage, String? owner}) {
    return ImageEntry._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      originalImage: originalImage,
      maskImage: maskImage,
      owner: owner);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ImageEntry &&
      id == other.id &&
      _originalImage == other._originalImage &&
      _maskImage == other._maskImage &&
      _owner == other._owner;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("ImageEntry {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("originalImage=" + "$_originalImage" + ", ");
    buffer.write("maskImage=" + "$_maskImage" + ", ");
    buffer.write("owner=" + "$_owner" + ", ");
    buffer.write("createdOn=" + (_createdOn != null ? _createdOn!.format() : "null") + ", ");
    buffer.write("updatedOn=" + (_updatedOn != null ? _updatedOn!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  ImageEntry copyWith({String? originalImage, String? maskImage, String? owner}) {
    return ImageEntry._internal(
      id: id,
      originalImage: originalImage ?? this.originalImage,
      maskImage: maskImage ?? this.maskImage,
      owner: owner ?? this.owner);
  }
  
  ImageEntry copyWithModelFieldValues({
    ModelFieldValue<String>? originalImage,
    ModelFieldValue<String>? maskImage,
    ModelFieldValue<String?>? owner
  }) {
    return ImageEntry._internal(
      id: id,
      originalImage: originalImage == null ? this.originalImage : originalImage.value,
      maskImage: maskImage == null ? this.maskImage : maskImage.value,
      owner: owner == null ? this.owner : owner.value
    );
  }
  
  ImageEntry.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _originalImage = json['originalImage'],
      _maskImage = json['maskImage'],
      _owner = json['owner'],
      _createdOn = json['createdOn'] != null ? amplify_core.TemporalDateTime.fromString(json['createdOn']) : null,
      _updatedOn = json['updatedOn'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedOn']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'originalImage': _originalImage, 'maskImage': _maskImage, 'owner': _owner, 'createdOn': _createdOn?.format(), 'updatedOn': _updatedOn?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'originalImage': _originalImage,
    'maskImage': _maskImage,
    'owner': _owner,
    'createdOn': _createdOn,
    'updatedOn': _updatedOn
  };

  static final amplify_core.QueryModelIdentifier<ImageEntryModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<ImageEntryModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final ORIGINALIMAGE = amplify_core.QueryField(fieldName: "originalImage");
  static final MASKIMAGE = amplify_core.QueryField(fieldName: "maskImage");
  static final OWNER = amplify_core.QueryField(fieldName: "owner");
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "ImageEntry";
    modelSchemaDefinition.pluralName = "ImageEntries";
    
    modelSchemaDefinition.authRules = [
      amplify_core.AuthRule(
        authStrategy: amplify_core.AuthStrategy.OWNER,
        ownerField: "owner",
        identityClaim: "cognito:username",
        provider: amplify_core.AuthRuleProvider.USERPOOLS,
        operations: const [
          amplify_core.ModelOperation.CREATE,
          amplify_core.ModelOperation.UPDATE,
          amplify_core.ModelOperation.DELETE,
          amplify_core.ModelOperation.READ
        ])
    ];
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ImageEntry.ORIGINALIMAGE,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ImageEntry.MASKIMAGE,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ImageEntry.OWNER,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.nonQueryField(
      fieldName: 'createdOn',
      isRequired: false,
      isReadOnly: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.nonQueryField(
      fieldName: 'updatedOn',
      isRequired: false,
      isReadOnly: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
  });
}

class _ImageEntryModelType extends amplify_core.ModelType<ImageEntry> {
  const _ImageEntryModelType();
  
  @override
  ImageEntry fromJson(Map<String, dynamic> jsonData) {
    return ImageEntry.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'ImageEntry';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [ImageEntry] in your schema.
 */
class ImageEntryModelIdentifier implements amplify_core.ModelIdentifier<ImageEntry> {
  final String id;

  /** Create an instance of ImageEntryModelIdentifier using [id] the primary key. */
  const ImageEntryModelIdentifier({
    required this.id});
  
  @override
  Map<String, dynamic> serializeAsMap() => (<String, dynamic>{
    'id': id
  });
  
  @override
  List<Map<String, dynamic>> serializeAsList() => serializeAsMap()
    .entries
    .map((entry) => (<String, dynamic>{ entry.key: entry.value }))
    .toList();
  
  @override
  String serializeAsString() => serializeAsMap().values.join('#');
  
  @override
  String toString() => 'ImageEntryModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is ImageEntryModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}