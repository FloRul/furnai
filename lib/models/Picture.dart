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


/** This is an auto generated class representing the Picture type in your schema. */
class Picture extends amplify_core.Model {
  static const classType = const _PictureModelType();
  final String id;
  final S3Object? _file;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;
  final String? _pictureFileId;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  PictureModelIdentifier get modelIdentifier {
      return PictureModelIdentifier(
        id: id
      );
  }
  
  S3Object get file {
    try {
      return _file!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  String get pictureFileId {
    try {
      return _pictureFileId!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  const Picture._internal({required this.id, required file, createdAt, updatedAt, required pictureFileId}): _file = file, _createdAt = createdAt, _updatedAt = updatedAt, _pictureFileId = pictureFileId;
  
  factory Picture({String? id, required S3Object file, required String pictureFileId}) {
    return Picture._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      file: file,
      pictureFileId: pictureFileId);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Picture &&
      id == other.id &&
      _file == other._file &&
      _pictureFileId == other._pictureFileId;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("Picture {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null") + ", ");
    buffer.write("pictureFileId=" + "$_pictureFileId");
    buffer.write("}");
    
    return buffer.toString();
  }
  
  Picture copyWith({S3Object? file, String? pictureFileId}) {
    return Picture._internal(
      id: id,
      file: file ?? this.file,
      pictureFileId: pictureFileId ?? this.pictureFileId);
  }
  
  Picture copyWithModelFieldValues({
    ModelFieldValue<S3Object>? file,
    ModelFieldValue<String>? pictureFileId
  }) {
    return Picture._internal(
      id: id,
      file: file == null ? this.file : file.value,
      pictureFileId: pictureFileId == null ? this.pictureFileId : pictureFileId.value
    );
  }
  
  Picture.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _file = json['file']?['serializedData'] != null
        ? S3Object.fromJson(new Map<String, dynamic>.from(json['file']['serializedData']))
        : null,
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null,
      _pictureFileId = json['pictureFileId'];
  
  Map<String, dynamic> toJson() => {
    'id': id, 'file': _file?.toJson(), 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format(), 'pictureFileId': _pictureFileId
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'file': _file,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt,
    'pictureFileId': _pictureFileId
  };

  static final amplify_core.QueryModelIdentifier<PictureModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<PictureModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final FILE = amplify_core.QueryField(
    fieldName: "file",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'S3Object'));
  static final PICTUREFILEID = amplify_core.QueryField(fieldName: "pictureFileId");
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Picture";
    modelSchemaDefinition.pluralName = "Pictures";
    
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
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.hasOne(
      key: Picture.FILE,
      isRequired: true,
      ofModelName: 'S3Object',
      associatedKey: S3Object.ID
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.nonQueryField(
      fieldName: 'createdAt',
      isRequired: false,
      isReadOnly: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.nonQueryField(
      fieldName: 'updatedAt',
      isRequired: false,
      isReadOnly: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Picture.PICTUREFILEID,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
  });
}

class _PictureModelType extends amplify_core.ModelType<Picture> {
  const _PictureModelType();
  
  @override
  Picture fromJson(Map<String, dynamic> jsonData) {
    return Picture.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'Picture';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [Picture] in your schema.
 */
class PictureModelIdentifier implements amplify_core.ModelIdentifier<Picture> {
  final String id;

  /** Create an instance of PictureModelIdentifier using [id] the primary key. */
  const PictureModelIdentifier({
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
  String toString() => 'PictureModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is PictureModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}