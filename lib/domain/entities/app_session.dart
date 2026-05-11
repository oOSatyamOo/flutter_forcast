import 'package:equatable/equatable.dart';

/// **AppSession** — Pure domain entity.
/// Represents a single app lifecycle session with open and exit timestamps.
class AppSession extends Equatable {
  final int? id;
  final DateTime openTime;
  final DateTime? exitTime;
  final DateTime createdAt;

  const AppSession({
    this.id,
    required this.openTime,
    this.exitTime,
    required this.createdAt,
  });

  AppSession copyWith({int? id, DateTime? openTime, DateTime? exitTime}) {
    return AppSession(
      id: id ?? this.id,
      openTime: openTime ?? this.openTime,
      exitTime: exitTime ?? this.exitTime,
      createdAt: createdAt,
    );
  }

  @override
  List<Object?> get props => [id, openTime, exitTime, createdAt];
}
