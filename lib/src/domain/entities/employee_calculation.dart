class EmployeeCalculation {
  final String id;
  final String name;
  final double salary;
  final double yearsOfExperience;
  final double bonus;
  final double finalSalary;
  final DateTime calculationDate;

  EmployeeCalculation({
    required this.id,
    required this.name,
    required this.salary,
    required this.yearsOfExperience,
    required this.bonus,
    required this.finalSalary,
    required this.calculationDate,
  });

  factory EmployeeCalculation.fromResultEmployee({
    required String id,
    required String name,
    required double salary,
    required double yearsOfExperience,
    required double bonus,
    required double finalSalary,
    DateTime? calculationDate,
  }) {
    return EmployeeCalculation(
      id: id,
      name: name,
      salary: salary,
      yearsOfExperience: yearsOfExperience,
      bonus: bonus,
      finalSalary: finalSalary,
      calculationDate: calculationDate ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'salary': salary,
      'yearsOfExperience': yearsOfExperience,
      'bonus': bonus,
      'finalSalary': finalSalary,
      'calculationDate': calculationDate.millisecondsSinceEpoch,
    };
  }

  factory EmployeeCalculation.fromJson(Map<String, dynamic> json) {
    return EmployeeCalculation(
      id: json['id'],
      name: json['name'],
      salary: json['salary'].toDouble(),
      yearsOfExperience: json['yearsOfExperience'].toDouble(),
      bonus: json['bonus'].toDouble(),
      finalSalary: json['finalSalary'].toDouble(),
      calculationDate: DateTime.fromMillisecondsSinceEpoch(json['calculationDate']),
    );
  }
}