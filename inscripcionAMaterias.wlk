
class Estudiante {
  var carreras = #{}
  var materiasCursadas = #{}

  method inscribirseA(_carrera) {
    self.validarInscribirseA(_carrera)
    carreras.add(_carrera)
  }
  method validarInscribirseA(_carrera) {
    if(carreras.contains(_carrera)) {
      self.error("Ya esta inscripto en la carrera")
    }
  }
  method carreras() {
    return carreras
  }
  method materiaPerteneceACarrera(_materia) {
    return carreras.any({carrera => carrera.materias().contains(_materia)})
  }
  method estaInscriptaEn(_carrera) {
    return carreras.contains(_carrera)
  }
  method finalizoLaCursadaDe(_materia, _nota) {
    self.validarFinalizoLaCursadaDe(_materia,_nota)
    
    const cursadaDeMateria = new NotaDeMateria()

    cursadaDeMateria.nota(_nota)
    cursadaDeMateria.materia(_materia)

    materiasCursadas.add(cursadaDeMateria)
  }
  method validarFinalizoLaCursadaDe(_materia, _nota) {
    if ((_nota < 1 || _nota > 10 ) || self.aproboLaMateria(_materia) || not self.materiaPerteneceACarrera(_materia)) {
      self.error("No se puede registrar la materia")
    }
  }
  method aproboLaMateria(_materia) {
    return materiasCursadas.any({notaDeMateria => notaDeMateria.materia() == _materia && notaDeMateria.nota() >= 6})
  }
  method promedioDe(_carrera) {
    return self.sumaDeNotasAprobadasDe(_carrera) / self.cantDeMateriasAprobadas(_carrera)
  }
  method sumaDeNotasAprobadasDe(_carrera) {
    return self.materiasAprobadasDe(_carrera).sum({notaDeMateria => notaDeMateria.nota()})
  }
  method materiasAprobadasDe(_carrera) {
    return materiasCursadas.filter({notaDeMateria => notaDeMateria.materia().carrera() == _carrera
           && notaDeMateria.nota() >=6})
  }
  method cantDeMateriasAprob() {
    return materiasCursadas.count({notaDeMateria => notaDeMateria.nota() >=6})
  }
  method cantDeMateriasAprobadas(_carrera) {
    return self.materiasAprobadasDe(_carrera).size()
  }
  method promedioDeMateriasAprobadasDeCarreras() {
    return self.sumaDeNotasAprobadas() / self.cantDeMateriasAprob()
  }
  method sumaDeNotasAprobadas() {
    return self.materiasCursadasAprobadas().sum({notaDeMateria => notaDeMateria.nota() })
  }
  method materiasCursadasAprobadas() {
    return materiasCursadas.filter({notaDeMateria => notaDeMateria.nota() >= 6})
  }

}

class Materia {
  var carrera = null

  method añadirCarrera(_carrera) {
    carrera = _carrera
  }
  method carrera() {
    return carrera
  }
}

class Carrera {
  var materias = #{}

  method materias() {
    return materias
  }
  method agregarMateria(_materia) {
    materias.add(_materia)
     _materia.añadirCarrera(self)
  }
}

class NotaDeMateria {
  var property nota = 0
  var property materia = null
}