class FirebaseTaskModel {
  final String? userId;
  final String? title;
  final String? date;
  final String? time;
  final String? image;
  final String? status;

  FirebaseTaskModel(
      {this.userId, this.title, this.date, this.time, this.image, this.status});

  factory FirebaseTaskModel.fromJson(Map<String, dynamic> json) {
    return FirebaseTaskModel(
        userId: json['userId'],
        title: json['title'],
        date: json['date'],
        time: json['time'],
        image: json['image'],
        status: json['status']);
  }

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'title': title,
        'date': date,
        'time': time,
        'image': image,
        'status': status
      };
}
