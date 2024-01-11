// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prayer_time.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PrayerTimeAdapter extends TypeAdapter<PrayerTime> {
  @override
  final int typeId = 1;

  @override
  PrayerTime read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PrayerTime()
      .._fajr = fields[0] as String?
      .._sunrise = fields[1] as String?
      .._dhuhr = fields[2] as String?
      .._asr = fields[3] as String?
      .._sunset = fields[4] as String?
      .._maghrib = fields[5] as String?
      .._isha = fields[6] as String?
      .._imsak = fields[7] as String?
      .._midnight = fields[8] as String?
      .._firstthird = fields[9] as String?
      .._lastthird = fields[10] as String?
      .._date = fields[11] as Date?;
  }

  @override
  void write(BinaryWriter writer, PrayerTime obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj._fajr)
      ..writeByte(1)
      ..write(obj._sunrise)
      ..writeByte(2)
      ..write(obj._dhuhr)
      ..writeByte(3)
      ..write(obj._asr)
      ..writeByte(4)
      ..write(obj._sunset)
      ..writeByte(5)
      ..write(obj._maghrib)
      ..writeByte(6)
      ..write(obj._isha)
      ..writeByte(7)
      ..write(obj._imsak)
      ..writeByte(8)
      ..write(obj._midnight)
      ..writeByte(9)
      ..write(obj._firstthird)
      ..writeByte(10)
      ..write(obj._lastthird)
      ..writeByte(11)
      ..write(obj._date);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PrayerTimeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DateAdapter extends TypeAdapter<Date> {
  @override
  final int typeId = 2;

  @override
  Date read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Date()
      .._readable = fields[0] as String?
      .._timestamp = fields[1] as String?
      .._gregorian = fields[2] as Gregorian?
      .._hijri = fields[3] as Hijri?;
  }

  @override
  void write(BinaryWriter writer, Date obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj._readable)
      ..writeByte(1)
      ..write(obj._timestamp)
      ..writeByte(2)
      ..write(obj._gregorian)
      ..writeByte(3)
      ..write(obj._hijri);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class GregorianAdapter extends TypeAdapter<Gregorian> {
  @override
  final int typeId = 3;

  @override
  Gregorian read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Gregorian()
      .._date = fields[0] as String?
      .._format = fields[1] as String?
      .._day = fields[2] as String?
      .._weekday = fields[3] as Weekday?
      .._month = fields[4] as Month?
      .._year = fields[5] as String?
      .._designation = fields[6] as Designation?;
  }

  @override
  void write(BinaryWriter writer, Gregorian obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj._date)
      ..writeByte(1)
      ..write(obj._format)
      ..writeByte(2)
      ..write(obj._day)
      ..writeByte(3)
      ..write(obj._weekday)
      ..writeByte(4)
      ..write(obj._month)
      ..writeByte(5)
      ..write(obj._year)
      ..writeByte(6)
      ..write(obj._designation);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GregorianAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DesignationAdapter extends TypeAdapter<Designation> {
  @override
  final int typeId = 4;

  @override
  Designation read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Designation()
      .._abbreviated = fields[0] as String?
      .._expanded = fields[1] as String?;
  }

  @override
  void write(BinaryWriter writer, Designation obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj._abbreviated)
      ..writeByte(1)
      ..write(obj._expanded);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DesignationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class HijriAdapter extends TypeAdapter<Hijri> {
  @override
  final int typeId = 5;

  @override
  Hijri read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Hijri()
      .._date = fields[0] as String?
      .._format = fields[1] as String?
      .._day = fields[2] as String?
      .._weekday = fields[3] as Weekday?
      .._month = fields[4] as Month?
      .._year = fields[5] as String?;
  }

  @override
  void write(BinaryWriter writer, Hijri obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj._date)
      ..writeByte(1)
      ..write(obj._format)
      ..writeByte(2)
      ..write(obj._day)
      ..writeByte(3)
      ..write(obj._weekday)
      ..writeByte(4)
      ..write(obj._month)
      ..writeByte(5)
      ..write(obj._year);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HijriAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class WeekdayAdapter extends TypeAdapter<Weekday> {
  @override
  final int typeId = 6;

  @override
  Weekday read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Weekday()
      .._en = fields[0] as String?
      .._ar = fields[1] as String?;
  }

  @override
  void write(BinaryWriter writer, Weekday obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj._en)
      ..writeByte(1)
      ..write(obj._ar);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WeekdayAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MonthAdapter extends TypeAdapter<Month> {
  @override
  final int typeId = 7;

  @override
  Month read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Month()
      .._number = fields[0] as int?
      .._en = fields[1] as String?
      .._ar = fields[2] as String?;
  }

  @override
  void write(BinaryWriter writer, Month obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj._number)
      ..writeByte(1)
      ..write(obj._en)
      ..writeByte(2)
      ..write(obj._ar);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MonthAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
