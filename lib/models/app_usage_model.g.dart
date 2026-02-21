part of 'app_usage_model.dart';

class AppUsageAdapter extends TypeAdapter<AppUsage> {
  @override
  final int typeId = 1;

  @override
  AppUsage read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AppUsage(
      date: fields[0] as DateTime,
      openCount: fields[1] as int? ?? 0,
      articlesRead: fields[2] as int? ?? 0,
      categoryReads: (fields[3] as Map?)?.cast<String, int>() ?? {},
      bookmarkCount: fields[4] as int? ?? 0,
    );
  }

  @override
  void write(BinaryWriter writer, AppUsage obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.openCount)
      ..writeByte(2)
      ..write(obj.articlesRead)
      ..writeByte(3)
      ..write(obj.categoryReads)
      ..writeByte(4)
      ..write(obj.bookmarkCount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppUsageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
