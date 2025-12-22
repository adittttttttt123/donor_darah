class UserModel {
  final String id;
  final String nama;
  final String email;
  final String noHp;
  final String golDarah;
  final String tglLahir;
  final String alamat;
  final String?
  profileImage; // Optional, defaults can be handled in UI or Controller

  UserModel({
    required this.id,
    required this.nama,
    required this.email,
    required this.noHp,
    this.golDarah = '-',
    this.tglLahir = '-',
    this.alamat = '-',
    this.profileImage,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String? ?? '',
      nama: json['nama'] as String? ?? '',
      email: json['email'] as String? ?? '',
      noHp: json['no_hp'] as String? ?? '',
      golDarah: json['gol_darah'] as String? ?? '-',
      tglLahir: json['tgl_lahir'] as String? ?? '-',
      alamat: json['alamat'] as String? ?? '-',
      profileImage: json['profile_image'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'email': email,
      'no_hp': noHp,
      'gol_darah': golDarah,
      'tgl_lahir': tglLahir,
      'alamat': alamat,
      // 'profile_image': profileImage, // Uncomment if you add this column to DB
    };
  }

  static UserModel empty() {
    return UserModel(id: '', nama: '', email: '', noHp: '');
  }

  UserModel copyWith({
    String? id,
    String? nama,
    String? email,
    String? noHp,
    String? golDarah,
    String? tglLahir,
    String? alamat,
    String? profileImage,
  }) {
    return UserModel(
      id: id ?? this.id,
      nama: nama ?? this.nama,
      email: email ?? this.email,
      noHp: noHp ?? this.noHp,
      golDarah: golDarah ?? this.golDarah,
      tglLahir: tglLahir ?? this.tglLahir,
      alamat: alamat ?? this.alamat,
      profileImage: profileImage ?? this.profileImage,
    );
  }
}
