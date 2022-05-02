import 'package:mobx/mobx.dart';
part 'detailpage_store.g.dart';

class DetailPageStore = _DetailPageStoreBase with _$DetailPageStore;

abstract class _DetailPageStoreBase with Store {
/* Se quiser globalizar esse arquivo para as outras abas (ex: Quarto, Sala de estar...)
recomendo especificar bem o nome da variavel Ex: activeMonitoringLivingRoom.
Se quiser manter o valor do Swtich do 'Alarme' e 'Notificação' quando mudar de tela
pode seguir o mesmo exemplo do activeMonitoring
*/

  @observable
  bool activeMonitoring = false;
}
