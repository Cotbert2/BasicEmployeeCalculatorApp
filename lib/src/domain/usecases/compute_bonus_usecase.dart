import './../entities/employee.dart';
import './../entities/result_employee.dart';

class ComputeBonusUseCase {
  ResultEmployee call(Employee employee) {
    double bonus = 0;

    if (employee.salary < 500){
      bonus = (employee.yearsOfExperience >= 10) ?
      employee.salary * 0.20 : 
      employee.salary * 0.05;
    }
    double finalSalary = employee.salary + bonus;
    return ResultEmployee(name: employee.name, bonus: bonus, finalSalary: finalSalary);
  }
}