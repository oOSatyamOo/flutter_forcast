import '../../domain/entities/app_session.dart';

/// **AppSessionModel** — Data layer model for lifecycle session tracking.
class AppSessionModel extends AppSession {
  const AppSessionModel({
    super.id,
    required super.openTime,
    super.exitTime,
    required super.createdAt,
  });

  factory AppSessionModel.fromMap(Map<String, dynamic> map) {
    return AppSessionModel(
      id: map['id'] as int?,
      openTime: DateTime.parse(map['open_time'] as String),
      exitTime: map['exit_time'] != null
          ? DateTime.parse(map['exit_time'] as String)
          : null,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'open_time': openTime.toIso8601String(),
      'exit_time': exitTime?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
    };
  }
}
