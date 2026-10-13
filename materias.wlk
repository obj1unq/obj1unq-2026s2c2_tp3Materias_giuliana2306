class Materia {
  var carrera = null
  var requisito = sinRequisitos
  var estudiantesInscriptos = #{}
  var correlativas = #{}
  var property año = 0
  var property creditos = 0
  var property creditosRequeridos = 0

  method añadirCarrera(_carrera) {
    carrera = _carrera
  }
  method carrera() {
    return carrera
  }
  method estudiantesInscriptos() {
    return estudiantesInscriptos
  }
  method añadirEstudiante(_estudiante) {
    estudiantesInscriptos.add(_estudiante)
  }
  method agregarCorrelativas(_correlativas) {
    correlativas = _correlativas
  }
  method agregarRequisito(_requisito) {
    requisito = _requisito
  }
  method correlativas() {
    return correlativas
  }
  method requisito() {
    return requisito
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
  method materiasAnterioresA(_materia) {
    return materias.filter({materia => materia.año() == (_materia.año() - 1)})
  }
}

class NotaDeMateria {
  var property nota = 0
  var property materia = null
}

object creditos {

  method cumpleElRequisito(_estudiante,_materia) {
    return  _estudiante.historiaAcademica().creditosDe(_materia.carrera()) >= _materia.creditosRequeridos()
  }
}

object correlativas {

  method cumpleElRequisito(_estudiante, _materia) {
    return _materia.correlativas().all({materia => _estudiante.aproboLaMateria(materia)})
  }
}

object porAño {

  method cumpleElRequisito(_estudiante, _materia) {
    return _materia.carrera().materiasAnterioresA(_materia).all({materia => _estudiante.aproboLaMateria(materia)})
  }
}
object sinRequisitos {
  
  method cumpleElRequisito(_estudiante, _materia) {
    return true
  }
}