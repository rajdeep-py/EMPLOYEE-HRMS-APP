// ============================================================
//  attendance.dart — Attendance & Check-in/out Model
// ============================================================

enum AttendanceStatus { checkedOut, checkedIn, onBreak }

class AttendanceRecord {
  final String id;
  final String employeeId;
  final DateTime date;
  final DateTime? checkInTime;
  final DateTime? checkOutTime;
  final String? checkInPhotoPath;   // local file path of selfie
  final String? checkOutPhotoPath;
  final double? checkInLatitude;
  final double? checkInLongitude;
  final double? checkOutLatitude;
  final double? checkOutLongitude;
  final String? checkInAddress;
  final String? checkOutAddress;
  final AttendanceStatus status;

  const AttendanceRecord({
    required this.id,
    required this.employeeId,
    required this.date,
    this.checkInTime,
    this.checkOutTime,
    this.checkInPhotoPath,
    this.checkOutPhotoPath,
    this.checkInLatitude,
    this.checkInLongitude,
    this.checkOutLatitude,
    this.checkOutLongitude,
    this.checkInAddress,
    this.checkOutAddress,
    this.status = AttendanceStatus.checkedOut,
  });

  AttendanceRecord copyWith({
    String? id,
    String? employeeId,
    DateTime? date,
    DateTime? checkInTime,
    DateTime? checkOutTime,
    String? checkInPhotoPath,
    String? checkOutPhotoPath,
    double? checkInLatitude,
    double? checkInLongitude,
    double? checkOutLatitude,
    double? checkOutLongitude,
    String? checkInAddress,
    String? checkOutAddress,
    AttendanceStatus? status,
  }) {
    return AttendanceRecord(
      id:                id               ?? this.id,
      employeeId:        employeeId        ?? this.employeeId,
      date:              date              ?? this.date,
      checkInTime:       checkInTime       ?? this.checkInTime,
      checkOutTime:      checkOutTime      ?? this.checkOutTime,
      checkInPhotoPath:  checkInPhotoPath  ?? this.checkInPhotoPath,
      checkOutPhotoPath: checkOutPhotoPath ?? this.checkOutPhotoPath,
      checkInLatitude:   checkInLatitude   ?? this.checkInLatitude,
      checkInLongitude:  checkInLongitude  ?? this.checkInLongitude,
      checkOutLatitude:  checkOutLatitude  ?? this.checkOutLatitude,
      checkOutLongitude: checkOutLongitude ?? this.checkOutLongitude,
      checkInAddress:    checkInAddress    ?? this.checkInAddress,
      checkOutAddress:   checkOutAddress   ?? this.checkOutAddress,
      status:            status            ?? this.status,
    );
  }

  /// Total hours worked (null if not checked in + out).
  Duration? get workedDuration {
    if (checkInTime == null || checkOutTime == null) return null;
    return checkOutTime!.difference(checkInTime!);
  }

  factory AttendanceRecord.fromJson(Map<String, dynamic> json) {
    return AttendanceRecord(
      id:                json['id']               as String,
      employeeId:        json['employeeId']        as String,
      date:              DateTime.parse(json['date'] as String),
      checkInTime:       json['checkInTime']  != null
          ? DateTime.parse(json['checkInTime'] as String) : null,
      checkOutTime:      json['checkOutTime'] != null
          ? DateTime.parse(json['checkOutTime'] as String) : null,
      checkInPhotoPath:  json['checkInPhotoPath']  as String?,
      checkOutPhotoPath: json['checkOutPhotoPath'] as String?,
      checkInLatitude:   (json['checkInLatitude']  as num?)?.toDouble(),
      checkInLongitude:  (json['checkInLongitude'] as num?)?.toDouble(),
      checkOutLatitude:  (json['checkOutLatitude']  as num?)?.toDouble(),
      checkOutLongitude: (json['checkOutLongitude'] as num?)?.toDouble(),
      checkInAddress:    json['checkInAddress']  as String?,
      checkOutAddress:   json['checkOutAddress'] as String?,
      status: AttendanceStatus.values.firstWhere(
        (e) => e.name == (json['status'] as String? ?? 'checkedOut'),
        orElse: () => AttendanceStatus.checkedOut,
      ),
    );
  }

  Map<String, dynamic> toJson() => {
    'id':                id,
    'employeeId':        employeeId,
    'date':              date.toIso8601String(),
    'checkInTime':       checkInTime?.toIso8601String(),
    'checkOutTime':      checkOutTime?.toIso8601String(),
    'checkInPhotoPath':  checkInPhotoPath,
    'checkOutPhotoPath': checkOutPhotoPath,
    'checkInLatitude':   checkInLatitude,
    'checkInLongitude':  checkInLongitude,
    'checkOutLatitude':  checkOutLatitude,
    'checkOutLongitude': checkOutLongitude,
    'checkInAddress':    checkInAddress,
    'checkOutAddress':   checkOutAddress,
    'status':            status.name,
  };
}
