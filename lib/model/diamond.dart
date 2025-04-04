// Diamond Model
class Diamond {
  final String? lotId;
  final String? size;
  final double? carat;
  final String? lab;
  final String? shape;
  final String? color;
  final String? clarity;
  final String? cut;
  final String? polish;
  final String? symmetry;
  final String? fluorescence;
  final double? discount;
  final double? perCaratRate;
  final double? finalAmount;

  Diamond({
    this.lotId,
    this.size,
    this.carat,
    this.lab,
    this.shape,
    this.color,
    this.clarity,
    this.cut,
    this.polish,
    this.symmetry,
    this.fluorescence,
    this.discount,
    this.perCaratRate,
    this.finalAmount,
  });

  factory Diamond.fromJson(Map<String, dynamic> json) {
    return Diamond(
      lotId: json['Lot ID'].toString(),
      size: json['Size'],
      carat: (json['Carat'] as num?)?.toDouble(),
      lab: json['Lab'],
      shape: json['Shape'],
      color: json['Color'],
      clarity: json['Clarity'],
      cut: json['Cut'],
      polish: json['Polish'],
      symmetry: json['Symmetry'],
      fluorescence: json['Fluorescence'],
      discount: (json['Discount'] as num?)?.toDouble(),
      perCaratRate: (json['Per Carat Rate'] as num?)?.toDouble(),
      finalAmount: (json['Final Amount'] as num?)?.toDouble(),
    );
  }

  factory Diamond.fromJsonLocal(Map<String, dynamic> json) {
    return Diamond(
      lotId: json['lotId'].toString(),
      size: json['size'],
      carat: (json['carat'] as num?)?.toDouble(),
      lab: json['lab'],
      shape: json['shape'],
      color: json['color'],
      clarity: json['clarity'],
      cut: json['cut'],
      polish: json['polish'],
      symmetry: json['symmetry'],
      fluorescence: json['fluorescence'],
      discount: (json['discount'] as num?)?.toDouble(),
      perCaratRate: (json['perCaratRate'] as num?)?.toDouble(),
      finalAmount: (json['finalAmount'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'lotId': lotId,
      'size': size,
      'carat': carat,
      'lab': lab,
      'shape': shape,
      'color': color,
      'clarity': clarity,
      'cut': cut,
      'polish': polish,
      'symmetry': symmetry,
      'fluorescence': fluorescence,
      'discount': discount,
      'perCaratRate': perCaratRate,
      'finalAmount': finalAmount,
    };
  }
}
