class EmployeeValidator {
  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'El nombre es obligatorio';
    }
    if (value.trim().length < 2) {
      return 'El nombre debe tener al menos 2 caracteres';
    }
    return null;
  }

  static String? validateSalary(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'El salario es obligatorio';
    }
    
    final salary = double.tryParse(value.trim());
    if (salary == null) {
      return 'Ingrese un salario válido';
    }
    
    if (salary <= 0) {
      return 'El salario debe ser mayor a 0';
    }
    
    if (salary > 999999) {
      return 'El salario no puede ser mayor a \$999,999';
    }
    
    return null;
  }

  static String? validateYearsOfExperience(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Los años de experiencia son obligatorios';
    }
    
    final years = double.tryParse(value.trim());
    if (years == null) {
      return 'Ingrese años de experiencia válidos';
    }
    
    if (years < 0) {
      return 'Los años de experiencia no pueden ser negativos';
    }
    
    if (years > 80) {
      return 'Los años de experiencia no pueden ser mayores a 80';
    }
    
    return null;
  }

  static bool isValidEmployee(String name, String salary, String yearsOfExperience) {
    return validateName(name) == null &&
           validateSalary(salary) == null &&
           validateYearsOfExperience(yearsOfExperience) == null;
  }
}