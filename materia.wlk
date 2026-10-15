import Estudiante.*
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