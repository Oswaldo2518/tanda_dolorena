import '../modelos/tanda.dart';
import '../modelos/cierre_ronda.dart';
import 'resultado_aportacion.dart';
import 'resultado_cierre.dart';

class ServicioTanda {
  final Tanda tanda;

  ServicioTanda(this.tanda);
  ResultadoAportacion registrarAportacion(String idParticipante) {
    final esParticipante = tanda.participantes.any(
      (p) => p.id == idParticipante,
    );

    if (!esParticipante) {
      return ResultadoAportacion.participanteInvalido;
    }

    if (tanda.aportacionesRondaActual.contains(idParticipante)) {
      return ResultadoAportacion.yaAporto;
    }

    tanda.aportacionesRondaActual.add(idParticipante);

    return ResultadoAportacion.registrada;
  }

  bool puedeCerrarRonda() {
    return tanda.participantes.every(
      (p) => tanda.aportacionesRondaActual.contains(p.id),
    );
  }

  CierreRonda cerrarRondaYAvanzar() {
    if (!puedeCerrarRonda()) {
      return CierreRonda(ResultadoCierre.faltanAportaciones, null);
    }

    final idBeneficiario = tanda.ordenTurnos[tanda.turnoActual];

    final beneficiario = tanda.participantes.firstWhere(
      (p) => p.id == idBeneficiario,
    );

    beneficiario.yaRecibioTurno = true;

    tanda.aportacionesRondaActual.clear();

    tanda.turnoActual++;

    return CierreRonda(ResultadoCierre.rondaCerrada, beneficiario);
  }
}
