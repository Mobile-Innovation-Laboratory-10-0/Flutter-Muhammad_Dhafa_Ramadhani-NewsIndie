part of 'bookmark_model.dart';

class BookmarkAdapter extends TypeAdapter<Bookmark> {
  @override
  final int typeId = 0;

  @override
  Bookmark read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Bookmark(
      articleId: fields[0] as String,
      title: fields[1] as String,
      imageUrl: fields[2] as String?,
      source: fields[3] as String,
      savedAt: fields[4] as DateTime,
      personalNote: fields[5] as String?,
      description: fields[6] as String?,
      url: fields[7] as String?,
      category: fields[8] as String? ?? 'general',
      publishedAt: fields[9] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Bookmark obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.articleId)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.imageUrl)
      ..writeByte(3)
      ..write(obj.source)
      ..writeByte(4)
      ..write(obj.savedAt)
      ..writeByte(5)
      ..write(obj.personalNote)
      ..writeByte(6)
      ..write(obj.description)
      ..writeByte(7)
      ..write(obj.url)
      ..writeByte(8)
      ..write(obj.category)
      ..writeByte(9)
      ..write(obj.publishedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookmarkAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
